# {{SYSTEM_NAME}} Architecture

**System Type:** {{SYSTEM_TYPE}}
**Last Updated:** {{DATE}}
**Complexity:** {{COMPLEXITY_LEVEL}}

---

## System Overview

{{HIGH_LEVEL_DESCRIPTION}}

**Purpose:**
{{SYSTEM_PURPOSE}}

**Key Responsibilities:**
- {{RESPONSIBILITY_1}}
- {{RESPONSIBILITY_2}}
- {{RESPONSIBILITY_3}}

---

## System Diagram

```
{{ASCII_SYSTEM_DIAGRAM}}
```

---

## Component Architecture

### Component 1: {{COMPONENT_1_NAME}}

**Purpose:** {{COMPONENT_1_PURPOSE}}

**Responsibilities:**
- {{COMPONENT_1_RESP_1}}
- {{COMPONENT_1_RESP_2}}

**Dependencies:**
- {{COMPONENT_1_DEP_1}}
- {{COMPONENT_1_DEP_2}}

**Implementation:** `{{COMPONENT_1_FILE_PATH}}`

**Diagram:**
```
{{COMPONENT_1_DIAGRAM}}
```

---

### Component 2: {{COMPONENT_2_NAME}}

**Purpose:** {{COMPONENT_2_PURPOSE}}

**Responsibilities:**
- {{COMPONENT_2_RESP_1}}
- {{COMPONENT_2_RESP_2}}

**Dependencies:**
- {{COMPONENT_2_DEP_1}}
- {{COMPONENT_2_DEP_2}}

**Implementation:** `{{COMPONENT_2_FILE_PATH}}`

**Diagram:**
```
{{COMPONENT_2_DIAGRAM}}
```

---

### Component 3: {{COMPONENT_3_NAME}}

**Purpose:** {{COMPONENT_3_PURPOSE}}

**Responsibilities:**
- {{COMPONENT_3_RESP_1}}
- {{COMPONENT_3_RESP_2}}

**Dependencies:**
- {{COMPONENT_3_DEP_1}}
- {{COMPONENT_3_DEP_2}}

**Implementation:** `{{COMPONENT_3_FILE_PATH}}`

---

## Data Flow

### Flow 1: {{FLOW_1_NAME}}

**Sequence:**
```
{{FLOW_1_START}}
  → {{FLOW_1_STEP_1}}
  → {{FLOW_1_STEP_2}}
  → {{FLOW_1_STEP_3}}
  → {{FLOW_1_END}}
```

**Data transformations:**
1. **{{FLOW_1_TRANSFORM_1_STAGE}}:** {{FLOW_1_TRANSFORM_1_DESC}}
2. **{{FLOW_1_TRANSFORM_2_STAGE}}:** {{FLOW_1_TRANSFORM_2_DESC}}

**Diagram:**
```
{{FLOW_1_DIAGRAM}}
```

---

### Flow 2: {{FLOW_2_NAME}}

**Sequence:**
```
{{FLOW_2_START}}
  → {{FLOW_2_STEP_1}}
  → {{FLOW_2_STEP_2}}
  → {{FLOW_2_END}}
```

**Data transformations:**
1. **{{FLOW_2_TRANSFORM_1_STAGE}}:** {{FLOW_2_TRANSFORM_1_DESC}}
2. **{{FLOW_2_TRANSFORM_2_STAGE}}:** {{FLOW_2_TRANSFORM_2_DESC}}

---

## Integration Points

### Integration 1: {{INTEGRATION_1_NAME}}

**Systems involved:** {{SYSTEM_A}} ↔ {{SYSTEM_B}}

**Communication protocol:** {{INTEGRATION_1_PROTOCOL}}

**Data exchanged:**
- **Direction:** {{SYSTEM_A}} → {{SYSTEM_B}}
- **Format:** {{INTEGRATION_1_FORMAT}}
- **Data:** {{INTEGRATION_1_DATA}}

**Implementation:**
```{{LANGUAGE}}
{{INTEGRATION_1_CODE}}
```

**Error handling:**
{{INTEGRATION_1_ERROR_HANDLING}}

---

### Integration 2: {{INTEGRATION_2_NAME}}

**Systems involved:** {{INTEGRATION_2_SYSTEM_A}} ↔ {{INTEGRATION_2_SYSTEM_B}}

**Communication protocol:** {{INTEGRATION_2_PROTOCOL}}

**Data exchanged:**
- **Direction:** {{INTEGRATION_2_DIRECTION}}
- **Format:** {{INTEGRATION_2_FORMAT}}
- **Data:** {{INTEGRATION_2_DATA}}

---

## State Management

**State storage:** {{STATE_STORAGE_MECHANISM}}

**State transitions:**
```
{{STATE_DIAGRAM}}
```

**Key states:**
- **{{STATE_1}}:** {{STATE_1_DESCRIPTION}}
- **{{STATE_2}}:** {{STATE_2_DESCRIPTION}}
- **{{STATE_3}}:** {{STATE_3_DESCRIPTION}}

**State persistence:** {{STATE_PERSISTENCE_STRATEGY}}

---

## Design Decisions

### Decision 1: {{DECISION_1_TITLE}}

**Context:**
{{DECISION_1_CONTEXT}}

**Options considered:**
1. **{{DECISION_1_OPTION_1}}** - {{DECISION_1_OPTION_1_DESC}}
2. **{{DECISION_1_OPTION_2}}** - {{DECISION_1_OPTION_2_DESC}}
3. **{{DECISION_1_OPTION_3}}** - {{DECISION_1_OPTION_3_DESC}}

**Decision:** {{DECISION_1_CHOICE}}

**Rationale:**
{{DECISION_1_RATIONALE}}

**Consequences:**
- ✅ {{DECISION_1_PRO_1}}
- ✅ {{DECISION_1_PRO_2}}
- ⚠️ {{DECISION_1_CON_1}}
- ⚠️ {{DECISION_1_CON_2}}

---

### Decision 2: {{DECISION_2_TITLE}}

**Context:**
{{DECISION_2_CONTEXT}}

**Decision:** {{DECISION_2_CHOICE}}

**Rationale:**
{{DECISION_2_RATIONALE}}

**Consequences:**
- ✅ {{DECISION_2_PRO_1}}
- ⚠️ {{DECISION_2_CON_1}}

---

## Scalability Considerations

### Performance Characteristics

**Current capacity:**
- {{CAPACITY_METRIC_1}}: {{CAPACITY_VALUE_1}}
- {{CAPACITY_METRIC_2}}: {{CAPACITY_VALUE_2}}

**Bottlenecks:**
1. **{{BOTTLENECK_1}}:** {{BOTTLENECK_1_DESC}}
   - **Impact:** {{BOTTLENECK_1_IMPACT}}
   - **Mitigation:** {{BOTTLENECK_1_MITIGATION}}

2. **{{BOTTLENECK_2}}:** {{BOTTLENECK_2_DESC}}
   - **Impact:** {{BOTTLENECK_2_IMPACT}}
   - **Mitigation:** {{BOTTLENECK_2_MITIGATION}}

**Optimization strategies:**
- {{OPTIMIZATION_1}}
- {{OPTIMIZATION_2}}
- {{OPTIMIZATION_3}}

---

### Scalability Path

**Horizontal scaling:**
{{HORIZONTAL_SCALING_STRATEGY}}

**Vertical scaling:**
{{VERTICAL_SCALING_STRATEGY}}

**Database scaling:**
{{DATABASE_SCALING_STRATEGY}}

---

## Security Considerations

**Authentication:** {{AUTH_MECHANISM}}

**Authorization:** {{AUTHZ_MECHANISM}}

**Data protection:**
- **In transit:** {{DATA_PROTECTION_TRANSIT}}
- **At rest:** {{DATA_PROTECTION_REST}}

**Security boundaries:**
```
{{SECURITY_BOUNDARY_DIAGRAM}}
```

---

## Failure Modes & Recovery

### Failure Mode 1: {{FAILURE_1_NAME}}

**Trigger:** {{FAILURE_1_TRIGGER}}

**Impact:** {{FAILURE_1_IMPACT}}

**Detection:** {{FAILURE_1_DETECTION}}

**Recovery:**
{{FAILURE_1_RECOVERY}}

---

### Failure Mode 2: {{FAILURE_2_NAME}}

**Trigger:** {{FAILURE_2_TRIGGER}}

**Impact:** {{FAILURE_2_IMPACT}}

**Recovery:**
{{FAILURE_2_RECOVERY}}

---

## Monitoring & Observability

**Metrics tracked:**
- {{METRIC_1}}: {{METRIC_1_DESC}}
- {{METRIC_2}}: {{METRIC_2_DESC}}
- {{METRIC_3}}: {{METRIC_3_DESC}}

**Logging:**
{{LOGGING_STRATEGY}}

**Alerting:**
{{ALERTING_STRATEGY}}

---

## Dependencies

### External Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| {{DEP_1}} | {{DEP_1_VERSION}} | {{DEP_1_PURPOSE}} |
| {{DEP_2}} | {{DEP_2_VERSION}} | {{DEP_2_PURPOSE}} |
| {{DEP_3}} | {{DEP_3_VERSION}} | {{DEP_3_PURPOSE}} |

### Internal Dependencies

| Component | Depends On | Reason |
|-----------|------------|--------|
| {{INTERNAL_DEP_1_COMPONENT}} | {{INTERNAL_DEP_1_TARGET}} | {{INTERNAL_DEP_1_REASON}} |
| {{INTERNAL_DEP_2_COMPONENT}} | {{INTERNAL_DEP_2_TARGET}} | {{INTERNAL_DEP_2_REASON}} |

---

## Future Considerations

**Planned improvements:**
1. {{FUTURE_1}}
2. {{FUTURE_2}}
3. {{FUTURE_3}}

**Technical debt:**
- {{TECH_DEBT_1}}
- {{TECH_DEBT_2}}

---

## Related Documentation

- [{{RELATED_DOC_1}}]({{RELATED_DOC_1_LINK}})
- [{{RELATED_DOC_2}}]({{RELATED_DOC_2_LINK}})
- [{{RELATED_DOC_3}}]({{RELATED_DOC_3_LINK}})

---

*Generated by docs-v2 skill using architecture workflow*
