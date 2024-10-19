## Misconfiguration Scanning for `terraform/`

The [`terraform/`][terraform] Configuration has been scanned and processed by [Trivy `{{ appVersion }}`][trivy] looking for known misconfigurations and potential operational issues relating to the deployed resources.

{{  if . -}}
The following table lists the files scanned and the misconfigurations found:
{{  else -}}
**No files or misconfigurations were found**.

```plain
0 Target (0 Misconfigurations)
```

{{- end }}
[terraform]: https://github.com/n3tuk/infra-flux/tree/main/terraform
[trivy]: https://trivy.dev/

{{- if . }}
{{-   $configurations := 0 }}
{{-   $misconfigurations := 0 }}
{{-   range . }}
{{-     $configurations = add $configurations 1 }}
{{-     $misconfigurations = add $misconfigurations (len .Misconfigurations) }}
{{-   end }}

```plain
{{ $configurations }} Configuration{{ if ne $configurations 1 }}s{{ end }} ({{ $misconfigurations }} Misconfiguration{{ if ne $misconfigurations 1 }}s{{ end }})
```

| Configuration | Pass | Critical | High | Medium | Low | Unknown |
| :------------ | :--: | :------: | :--: | :----: | :-: | :-----: |

{{-   range . }}
| {{    if (eq .Target ".") -}}
[`terraform/`](https://github.com/n3tuk/infra-flux/blob/main/terraform) |
{{-     else -}}
[`terraform/{{ escapeXML .Target }}`](https://github.com/n3tuk/infra-flux/blob/main/terraform/{{ escapeXML .Target }}) |
{{-     end }}
{{-     if (eq (len .Misconfigurations ) 0) }} Pass | 0 | 0 | 0 | 0 | 0 |
{{-     else }} **Fail** |
{{-       $critical := 0 }}
{{-       $high := 0 }}
{{-       $medium := 0 }}
{{-       $low := 0 }}
{{-       $unknown := 0 }}
{{-       range .Misconfigurations }}
{{-         if eq .Severity "CRITICAL" }}
{{-           $critical = add $critical 1 }}
{{-         end }}
{{-         if eq .Severity "HIGH" }}
{{-           $high = add $high 1 }}
{{-         end }}
{{-         if eq .Severity "MEDIUM" }}
{{-           $medium = add $medium 1 }}
{{-         end }}
{{-         if eq .Severity "LOW" }}
{{-           $low = add $low 1 }}
{{-         end }}
{{-         if eq .Severity "UNKNOWN" }}
{{-           $unknown = add $unknown 1 }}
{{-         end }}
{{-       end }} **{{ $critical }}** | **{{ $high }}** | **{{ $medium }}** | **{{ $low }}** | **{{ $unknown }}** |
{{-     end }}
{{-   end }}

{{-   if gt $misconfigurations 0 }}

### Misconfigurations ({{ $misconfigurations }})

Expanding on the summary in the table above, this is the breakdown of the individual misconfigurations identified by [Trivy][trivy] for all the scanned files in [`terraform/`][terraform]:

| Target | ID  | Severity | Title | Description | Message | Resolutions |
| :----- | :-: | :------: | :---- | :---------- | :------ | :---------- |

{{-     range . }}
{{-       $target := .Target }}
{{-       if (eq $target ".") }}
{{-         $target = "" }}
{{-       end }}
{{-       range .Misconfigurations }}
| [`terraform/{{ escapeXML $target }}`](https://github.com/n3tuk/infra-flux/blob/main/terraform/{{ escapeXML $target }}) | [`{{ escapeXML .AVDID }}`]({{ escapeXML .PrimaryURL }}) | {{ escapeXML .Severity }} | {{ escapeXML .Title }} | {{ escapeXML .Description }} | {{ escapeXML .Message }} | {{ escapeXML .Resolution }} ({{ range $index, $link := .References }}{{ if gt $index 0 }}, {{ end }}[link]({{ $link }}){{ end }}) |
{{-       end }}
{{-     end }}
{{-   end }}

{{- end }}
