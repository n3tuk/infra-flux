# n3t.uk Flux Artifact Repository

TODO

## Updates

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
