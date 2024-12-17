local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('eclipse-leshan') {
  settings+: {
    description: "",
    name: "Eclipse Leshan™",
    security_managers+: [
      "iot-leshan-project-leads"
    ],
    web_commit_signoff_required: false,
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },
  webhooks+: [
    orgs.newOrgWebhook('https://ci.eclipse.org/leshan/github-webhook/') {
      content_type: "json",
      events+: [
        "pull_request",
        "push"
      ],
    },
  ],
  _repositories+:: [
    orgs.newRepo('leshan') {
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      description: "Java Library for LWM2M",
      homepage: "https://www.eclipse.org/leshan/",
      private_vulnerability_reporting_enabled: true,
      topics+: [
        "bootstrap-server",
        "coap",
        "device-management",
        "eclipse",
        "eclipseiot",
        "internet-of-things",
        "iot",
        "java",
        "lwm2m",
        "lwm2m-client",
        "lwm2m-protocol",
        "lwm2m-server"
      ],
      web_commit_signoff_required: false,
    },
    orgs.newRepo('leshan-website') {
      allow_merge_commit: true,
      allow_update_branch: false,
      default_branch: "master",
      delete_branch_on_merge: false,
      private_vulnerability_reporting_enabled: true,
      web_commit_signoff_required: false,
      workflows+: {
        enabled: false,
      },
    },
  ],
} + {
  # snippet added due to 'https://github.com/EclipseFdn/otterdog-configs/blob/main/blueprints/add-dot-github-repo.yml'
  _repositories+:: [
    orgs.newRepo('.github')
  ],
}