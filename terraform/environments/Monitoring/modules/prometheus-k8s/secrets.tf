resource "kubernetes_secret" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = var.namespace
  }
  data = {
    "prometheus.yaml" = local.prometheus_config_yaml
  }
}

resource "kubernetes_secret" "tls-assets" {
  metadata {
    name      = "prometheus-tls-assets"
    namespace = var.namespace
  }
  data = {
    "ca.cert" = <<CA
-----BEGIN CERTIFICATE-----
MIIBczCCARmgAwIBAgIQZQodFQofYmBgi3FMVGCiszAKBggqhkjOPQQDAjAOMQww
CgYDVQQKEwNuaWwwIBcNMjEwODAzMjI1NTQ5WhgPMjEyMTA3MTAyMjU1NDlaMA4x
DDAKBgNVBAoTA25pbDBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABCEESZVGxN9W
8BoKOh8adaigImifus6gWbSf7B65ZPgrtDZmhntRAYCZF1tb7lYoYJi30ky/mMHp
Io41C7JvXCijVzBVMA4GA1UdDwEB/wQEAwICBDATBgNVHSUEDDAKBggrBgEFBQcD
ATAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSgczf6WA3sj3woy6jGz3rAQ4oW
oTAKBggqhkjOPQQDAgNIADBFAiBueqnNGLCmxS/TLIc81FWcPJX212MkrawvCDT2
ocvyDwIhAMLT5XOb0hn7q5aBjmeAllTzYTzTYNFOKcQZ5+fFI1C5
-----END CERTIFICATE-----
CA
  }
}
