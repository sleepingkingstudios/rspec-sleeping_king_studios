---
breadcrumbs:
  - name: Documentation
    path: '../'
version: '*'
---

{% assign root_namespace = site.namespaces | where: "version", page.version | first %}

# RSpec::SleepingKingStudios Reference

{% include reference/namespace.md label=false namespace=root_namespace %}

{% include breadcrumbs.md %}
