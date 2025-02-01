## Table Of Contents

<ul>
  {% include reference/definitions/table-of-contents/overview.md definition=include.definition %}

  {% if include.definition.direct_subclasses.size > 0 %}
  <li><a href="#direct-subclasses">Direct Subclasses</a></li>
  {% endif %}

  {% if include.definition.defined_classes.size > 0 or include.definitions.defined_modules.size > 0 %}
  <li><a href="#defined-under-namespace">Defined Under Namespace</a></li>
  {% endif %}

  {% include reference/definitions/table-of-contents/constants.md definition=include.definition %}

  {% include reference/definitions/table-of-contents/class_attributes.md definition=include.definition %}

  {% include reference/definitions/table-of-contents/class_methods.md definition=include.definition %}

  {% if include.definition.constructor %}
  <li><a href="#constructor">Constructor</a></li>
  {% endif %}

  {% include reference/definitions/table-of-contents/instance_attributes.md definition=include.definition %}

  {% include reference/definitions/table-of-contents/instance_methods.md definition=include.definition %}
</ul>
