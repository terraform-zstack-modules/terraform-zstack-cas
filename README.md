<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_zstack"></a> [zstack](#requirement\_zstack) | 1.0.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cas_image"></a> [cas\_image](#module\_cas\_image) | git::http://172.20.14.17/jiajian.chi/terraform-zstack-image.git | v1.1.1 |
| <a name="module_cas_instance"></a> [cas\_instance](#module\_cas\_instance) | git::http://172.20.14.17/jiajian.chi/terraform-zstack-instance.git | v1.1.1 |

## Resources

| Name | Type |
|------|------|
| [terraform_data.remote_exec](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_storage_name"></a> [backup\_storage\_name](#input\_backup\_storage\_name) | Name of the backup storage to use | `string` | `"Ceph"` | no |
| <a name="input_context"></a> [context](#input\_context) | Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.<br/><br/>Examples:<pre>context:<br/>  project:<br/>    name: string<br/>    id: string<br/>  environment:<br/>    name: string<br/>    id: string<br/>  resource:<br/>    name: string<br/>    id: string</pre> | `map(any)` | `{}` | no |
| <a name="input_expunge"></a> [expunge](#input\_expunge) | n/a | `bool` | `true` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Name for the log server image | `string` | `"cas-by-terraform"` | no |
| <a name="input_image_url"></a> [image\_url](#input\_image\_url) | URL to download the image from | `string` | `"http://minio.zstack.io:9001/packer/cas-by-packer-image-compressed.qcow2"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name for the cas server instance | `string` | `"cas"` | no |
| <a name="input_instance_offering_name"></a> [instance\_offering\_name](#input\_instance\_offering\_name) | Name of the instance offering to use | `string` | `"min"` | no |
| <a name="input_l3_network_name"></a> [l3\_network\_name](#input\_l3\_network\_name) | Name of the L3 network to use | `string` | `"test"` | no |
| <a name="input_ssh_password"></a> [ssh\_password](#input\_ssh\_password) | SSH password for remote access | `string` | `"password"` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | SSH username for remote access | `string` | `"root"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cas_access_urls"></a> [cas\_access\_urls](#output\_cas\_access\_urls) | CAS 访问 URL |
| <a name="output_cas_instance_id"></a> [cas\_instance\_id](#output\_cas\_instance\_id) | CAS 实例 ID |
| <a name="output_cas_instance_ip"></a> [cas\_instance\_ip](#output\_cas\_instance\_ip) | CAS 实例 IP 地址 |
| <a name="output_ports"></a> [ports](#output\_ports) | Service Ports |
| <a name="output_walrus_environment_id"></a> [walrus\_environment\_id](#output\_walrus\_environment\_id) | The id of environment where deployed in Walrus. |
| <a name="output_walrus_environment_name"></a> [walrus\_environment\_name](#output\_walrus\_environment\_name) | The name of environment where deployed in Walrus. |
| <a name="output_walrus_project_id"></a> [walrus\_project\_id](#output\_walrus\_project\_id) | The id of project where deployed in Walrus. |
| <a name="output_walrus_project_name"></a> [walrus\_project\_name](#output\_walrus\_project\_name) | The name of project where deployed in Walrus. |
| <a name="output_walrus_resource_id"></a> [walrus\_resource\_id](#output\_walrus\_resource\_id) | The id of resource where deployed in Walrus. |
| <a name="output_walrus_resource_name"></a> [walrus\_resource\_name](#output\_walrus\_resource\_name) | The name of resource where deployed in Walrus. |
<!-- END_TF_DOCS -->

## feature

- 基于 Apereo CAS 7.1.5
- Docker 容器化部署
- 静态用户认证（预配置三个测试账号）
- 支持 HTTP 访问（开发环境）

## 系统要求

- Docker 19.03+
- Docker Compose 1.27+
- 至少 1GB 可用内存
- 端口 8080 可用

## 快速开始


### 1. 访问 CAS 登录页面
根据输出访问

打开浏览器访问:
```
http://输出ip:8080/cas/login
```

### 2. 测试账号

系统预配置了三个测试账号:

| 用户名 | 密码 |
|--------|------|
| user1  | password |
| user2  | password |
| casuser  | password |

## 配置说明

### 添加或修改用户

编辑 `docker-compose.yml` 和 `cas-overlay/application.properties` 文件中的用户配置：

```yaml
# docker-compose.yml
environment:
  - CAS_AUTHN_ACCEPT_USERS=user1::password1,user2::password2,admin::adminpassword
```

```properties
# cas-overlay/application.properties
cas.authn.accept.users=user1::password1,user2::password2,admin::adminpassword
```

修改后重启服务:

```bash
docker-compose restart
```

### 启用/禁用服务注册

默认配置已禁用服务注册功能。如需启用，请修改 `application.properties`:

```properties
# 启用服务注册
cas.service-registry.core.init-from-json=true
cas.service-registry.json.enabled=true
cas.service-registry.json.location=file:/etc/cas/config/services
```

同时修改 `docker-compose.yml`:

```yaml
environment:
  - CAS_SERVICE_REGISTRY_CORE_INIT_FROM_JSON=true
  - CAS_SERVICE_REGISTRY_JSON_LOCATION=file:/etc/cas/config/services
```