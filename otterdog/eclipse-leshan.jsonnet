local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

local defaultBranchesProtection(branches) = 
  orgs.newRepoRuleset("branch-protection") {
    bypass_actors+: [
      "@eclipse-leshan/iot-leshan-project-leads",
      "@eclipse-leshan/bot-bypass"
    ],
    include_refs+: [std.format("refs/heads/%s", branch) for branch in branches],
    required_pull_request+: {
      required_approving_review_count: 1,
      requires_last_push_approval: true,
      requires_review_thread_resolution: true,
      dismisses_stale_reviews: true,
    },
    required_status_checks+: {
      strict: true,
    },
    requires_linear_history: true,
  };

local defaultTagsProtection(tags) = orgs.newRepoRuleset('tags-protection') {
  target: "tag",
  bypass_actors+: [
    "@eclipse-leshan/iot-leshan-project-leads"
  ],
  include_refs+: [std.format("refs/tags/%s", tag) for tag in tags],
  allows_creations: true,
  allows_deletions: false,	
  allows_updates: false,
  required_pull_request: null,
  required_status_checks: null,
};

orgs.newOrg('iot.leshan', 'eclipse-leshan') {
  settings+: {
    description: "",
    name: "Eclipse Leshan™",
    web_commit_signoff_required: false,
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },
  teams+: [
    orgs.newTeam('bot-bypass') {
      members+: [
        "eclipse-leshan-bot",
      ],
    },
  ],
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
      rulesets: [
        defaultBranchesProtection(["master","1.x"]), // protect in-dev and stable branches
        defaultTagsProtection(["leshan-*"]) // protect tags about release
      ],
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
