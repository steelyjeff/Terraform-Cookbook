resource_group_name = "RG-App"
service_plan_name    = "Plan-App"
environment         = "DEV09"


web_apps = {
  webapp1 = {
    "name"                     = "webappdemobook11"
    "location"                 = "East US"
    "dotnet_framework_version" = "v4.0"
    "serverdatabase_name"      = "server1"
  },
  webapp2 = {
    "name"                     = "webapptestbook12"
    "dotnet_framework_version" = "v4.0"
    "serverdatabase_name"      = "server2"
  }
}