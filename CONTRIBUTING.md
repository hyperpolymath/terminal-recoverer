# Contributing to Sentinel

Sentinel is intentionally small, predictable, and narratable.  
Contributions should preserve these qualities.

## Principles

- Keep behaviour explicit and user-controlled  
- Avoid background complexity or hidden state  
- Maintain timestamped, isolated artefacts  
- Prefer clarity over cleverness  
- Preserve reversibility

## How to Contribute

1. Open an issue describing the proposed change  
2. Explain how it fits Sentinel’s purpose and invariants  
3. Submit a PR with:
   - clear commit messages
   - updated documentation if needed
   - no breaking changes to the crash-capture schema

## Non-Goals

Sentinel does **not** aim to become:

- a monitoring daemon  
- a system-wide logging framework  
- a debugging suite  
- a performance profiler  

Keep the subsystem focused and humane.
