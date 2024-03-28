#resource "kubernetes_manifest" "karpenter_node_pool_default" {
#  manifest = {
#    apiVersion = "karpenter.sh/v1beta1"
#    kind       = "NodePool"
#    metadata   = { name = "linux-default" }
#    spec = {
#      template = {
#        spec = {
#          requirements = [
#            {
#              key      = "kubernetes.io/os"
#              operator = "In"
#              values   = ["linux"]
#            },
#            {
#              key      = "karpenter.k8s.aws/instance-category"
#              operator = "In"
#              values   = ["t", "r", "m"]
#            },
#            {
#              key      = "kubernetes.io/arch"
#              operator = "In"
#              values   = ["amd64"]
#            },
#            {
#              key      = "topology.kubernetes.io/zone"
#              operator = "In"
#              values   = var.availability_zones
#            },
#            {
#              key      = "karpenter.sh/capacity-type"
#              operator = "In"
#              values   = ["on-demand"]
#            }
#          ]
#          nodeClassRef = {
#            apiVersion = "karpenter.k8s.aws/v1beta1"
#            kind       = "EC2NodeClass"
#            name       = kubernetes_manifest.karpenter_node_class_default.manifest.metadata.name
#          }
#        }
#      }
#    }
#  }
#}
#
#resource "kubernetes_manifest" "karpenter_node_class_default" {
#  manifest = {
#    apiVersion = "karpenter.k8s.aws/v1beta1"
#    kind       = "EC2NodeClass"
#    metadata   = { name = "linux-default" }
#    spec = {
#      amiFamily          = "AL2"
#      detailedMonitoring = true
#      instanceProfile    = module.eks_addons.karpenter["node_instance_profile_name"]
#
#      metadataOptions = {
#        httpEndpoint            = "enabled"
#        httpProtocolIPv6        = "disabled"
#        httpPutResponseHopLimit = 2
#        httpTokens              = "required"
#      }
#
#      securityGroupSelectorTerms = [
#        {
#          tags = {
#            "karpenter.sh/discovery" = local.compute["cluster_name"]
#            "karpenter.sh/nodeClass" = "base"
#          }
#        },
#        {
#          tags = {
#            "karpenter.sh/discovery" = local.compute["cluster_name"]
#            "karpenter.sh/nodeClass" = "linux"
#          }
#        }
#      ]
#
#      subnetSelectorTerms = [
#        {
#          tags = { "karpenter.sh/discovery" = local.compute["cluster_name"] }
#        }
#      ]
#
#      tags = { Name = "${local.compute["cluster_name"]}-eks-worker-node-linux-default" }
#    }
#
#  }
#}
