# n3t.uk Flux Artifact Repository

## Bootstrapping

In order for [Flux][flux] to manage the [Talos][talos] Kubernetes clusters it
must be pre-installed using [Helm][helm]. This configures the [Custom Resource
Definitions][crds] (CRDs) which Flex will manage, and the resources which
[Terraform][terraform] will create and update.

[flux]: https://fluxcd.io/
[talos]: https://www.talos.dev/
[helm]: https://helm.sh/
[crds]: https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/
[terraform]: https://www.terraform.io/

The first step is to prepare the Kubernetes cluster. The commands following this
block assume that the configuration context and namespace have already been
selected within your local environment:

```console
$ kubectx admin@{environment}
✔ Switched to context "admin@{environment}".
$ kubectl config set-context --current --namespace=flux-system
```

Next, either add, or update, the [`fluxcd-community`][flux-community] Helm
repository so that we can bootstrap Flux by installing Flux via Helm (and hence
via [`HelmRelease`][helm-release] resources in the future) rather than manually
using the `flux` CLI tool:

[flux-community]: https://github.com/fluxcd-community/helm-charts
[helm-release]: https://fluxcd.io/flux/components/helm/helmreleases/

```console
$ helm repo add fluxcd-community https://fluxcd-community.github.io/helm-charts
"fluxcd-community" has been added to your repositories
```

```console
$ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "fluxcd-community" chart repository
Update Complete. ⎈Happy Helming!⎈
```

From here, Flux can be deployed, but with some minor overrides, specifically:

1. The CRDs for Prometheus will be installed by Flux, so for the time being we
   will temporarily disable the creation of [`PodMonitor`][podmonitor] resources
   through this Helm Chart, else Kubernetes will reject it.
2. The Flux webhook receiver for the Notification Controller requires both
   [`cert-manager`][cert-manager] installed, and [LetsEncrypt][letsencrypt]
   configured as an [`ClusterIssuer`][cluster-issuer] in order for the
   [`Certificate`][certificate] resource to be created and issues. Again, we
   therefore must disable this set of resources or Kubernetes will reject it.

[podmonitor]: https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.PodMonitor
[cert-manager]: https://cert-manager.io/
[letsencrypt]: https://letsencrypt.org/
[cluster-issuer]: https://cert-manager.io/docs/configuration/issuers/
[certificate]: https://cert-manager.io/docs/usage/certificate/

```console
$ kubectl create namespace flux-system
$ helm install flux fluxcd-community/flux2 \
    --values flux/flux/flux-values.yaml \
    --set prometheus.podMonitor.create=false \
    --set notificationController.webhookReceiver.ingress.create=false
NAME: fluxcd
LAST DEPLOYED: Thu Nov 21 14:17:19 2024
NAMESPACE: flux-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

Finally, we need to set up the credentials to allow Flux to access [GitHub
Container Registry][ghcr] where the `baseline` (and other) OCI images are stored
for Flux to retrieve. This will require a Classic Personal Access Token
configured with the `read:packages` scope:

1. Log into [GitHub][github] and navigate to _Settings_ > _Developer Settings_ >
   [_Tokens (Classic)_][tokens-classic], then either:
   1. Select the token named `source-controller@{environment}` and then click
      _Regenerate token_, select _No expiration_ for _Expiration_, and click
      _Regenerate token_ again to get a new token if the cluster is being
      rebuilt; or
   1. Click _Generate new token_ > _Generate new token (classic)_ and enter the
      Note as `source-controller@{environment}`, the _Expiration_ date as _No
      expiration_ (this will only be allowed to access packages), and select
      **only** the `read:packages` scope, then click _Generate token_.
1. Copy the personal access token from GitHub and run the following command:

```console
$ kubectl create secret docker-registry ghcr-login \
    --docker-server=ghcr.io \
    --docker-username={github_username}
    --docker-password={github_pat}
secret/ghcr-login created
```

[github]: https://github.com/
[tokens-classic]: https://github.com/settings/tokens
[ghcr]: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry

Flux is now bootstrapped. As such all the necessary resources are deployed so
that Terraform can plan and apply against the Kubernetes cluster, and create the
[`OCIRepository`][oci-repository] and [`Kustomization`][kustomization] resources
necessary for Flux to build and run.

[oci-repository]: https://fluxcd.io/flux/components/source/ocirepositories/
[kustomization]: https://fluxcd.io/flux/components/kustomize/kustomizations/

## Upgrading

TODO

## Updating

To avoid a dependency loop between (at a minimum) `prometheus-operator` and
`cert-manager` services, where both require each other to be installed before
they themselves can be installed, it's necessary to install the Custom Resource
Definitions for this services independently. That allows the creation of the
relevant resources, without installing the additional services they depend on.

### `prometheus-operator` CRDs

For the `prometheus-operator` CRDs, download the latest release of `bundle.yaml`
and store it in the `prometheus-operator.yaml` file under `flux/custom-resources`:

```console
wget https://github.com/prometheus-operator/prometheus-operator/releases/download/{release}/bundle.yaml \
  -o flux/custom-resources/prometheus-operator.yaml
```

### `cert-manager` CRDs

For the `cert-manager` CRDs, download the latest release of
`cert-manager.crds.yaml` and store it in the `cert-manager.yaml` file under
`flux/custom-resources`:

```console
wget https://github.com/cert-manager/cert-manager/releases/download/{release}/cert-manager.crds.yaml \
  -o flux/custom-resources/cert-manager.yaml
```

## Dependency Management

This repository uses [Renovate][renovate] for automated dependency management.
Renovate is configured to:

- Run weekly on Fridays at 18:00 (Europe/London time)
- Group minor and patch updates together to reduce PR noise
- Create separate PRs for major updates to allow careful review
- Support manual triggering via GitHub Actions workflow dispatch

[renovate]: https://docs.renovatebot.com/

### Supported Ecosystems

Renovate manages dependencies for the following ecosystems:

| Ecosystem      | Location                  | Labels                                         |
| -------------- | ------------------------- | ---------------------------------------------- |
| GitHub Actions | `.github/workflows/`      | `type/dependencies`, `update/github-workflows` |
| Terraform      | `terraform/`              | `type/dependencies`, `update/terraform`        |
| tflint         | `.tflint.hcl`             | `type/dependencies`, `update/tflint`           |
| pre-commit     | `.pre-commit-config.yaml` | `type/dependencies`, `update/pre-commit`       |
| Flux Helm      | `flux/**/*.yaml`          | `type/dependencies`, `update/flux`             |

To run Renovate manually:

1. Log in to GitHub and navigate to [_Actions_][gh-actions], and select the
   [_Renovate_][gha-renovate] workflow.
2. Click _Run workflow_.
3. Optionally enable dry-run mode for testing.

[gh-actions]: https://github.com/n3tuk/infra-flux/actions
[gha-renovate]: https://github.com/n3tuk/infra-flux/actions/workflows/renovate.yaml
