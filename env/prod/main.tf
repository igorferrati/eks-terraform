module "prod" {
    source = "../../infra"

    nome_repositorio = "producao"
    cluster_name = "eks-prd"
}

#output lb
output "endereco" {
  value = module.prod.URL
}