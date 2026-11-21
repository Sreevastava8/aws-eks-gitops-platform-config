package main

has_drop_all(container) if {
    security := object.get(container, "securityContext", {})
    capabilities := object.get(security, "capabilities", {})
    drops := object.get(capabilities, "drop", [])

    "ALL" in drops
}

deny contains msg if {
    input.kind == "Deployment"

    pod_security := object.get(
        input.spec.template.spec,
        "securityContext",
        {}
    )

    object.get(pod_security, "runAsNonRoot", false) != true

    msg := sprintf(
        "Deployment %s must run as non-root",
        [input.metadata.name]
    )
}

deny contains msg if {
    input.kind == "Deployment"

    container := input.spec.template.spec.containers[_]

    security := object.get(container, "securityContext", {})

    object.get(security, "allowPrivilegeEscalation", true) != false

    msg := sprintf(
        "Container %s must disable privilege escalation",
        [container.name]
    )
}

deny contains msg if {
    input.kind == "Deployment"

    container := input.spec.template.spec.containers[_]

    security := object.get(container, "securityContext", {})

    object.get(security, "readOnlyRootFilesystem", false) != true

    msg := sprintf(
        "Container %s must use a read-only root filesystem",
        [container.name]
    )
}

deny contains msg if {
    input.kind == "Deployment"

    container := input.spec.template.spec.containers[_]

    not has_drop_all(container)

    msg := sprintf(
        "Container %s must drop all Linux capabilities",
        [container.name]
    )
}

deny contains msg if {
    input.kind == "Deployment"

    container := input.spec.template.spec.containers[_]

    resources := object.get(container, "resources", {})
    requests := object.get(resources, "requests", {})

    not object.get(requests, "cpu", null)

    msg := sprintf(
        "Container %s must define CPU requests",
        [container.name]
    )
}

deny contains msg if {
    input.kind == "Deployment"

    container := input.spec.template.spec.containers[_]

    resources := object.get(container, "resources", {})
    limits := object.get(resources, "limits", {})

    not object.get(limits, "memory", null)

    msg := sprintf(
        "Container %s must define memory limits",
        [container.name]
    )
}

deny contains msg if {
    input.kind == "NetworkPolicy"

    policy_types := object.get(input.spec, "policyTypes", [])

    not "Ingress" in policy_types

    msg := sprintf(
        "NetworkPolicy %s must define Ingress",
        [input.metadata.name]
    )
}

deny contains msg if {
    input.kind == "NetworkPolicy"

    policy_types := object.get(input.spec, "policyTypes", [])

    not "Egress" in policy_types

    msg := sprintf(
        "NetworkPolicy %s must define Egress",
        [input.metadata.name]
    )
}