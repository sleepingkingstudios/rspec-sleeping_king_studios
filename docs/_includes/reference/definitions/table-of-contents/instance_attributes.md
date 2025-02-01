{% if include.definition.instance_attributes.size > 0 %}
<li>
  <a href="#instance-attributes">Instance Attributes</a>
  <ul style="margin-bottom: 0px;">
  {% for attribute in include.definition.instance_attributes %}
    <li><a href="#instance-attribute-{{ attribute.slug | replace: "=", "--equals" }}">{{ attribute.name }}</a></li>
  {% endfor %}
  </ul>
</li>
{% endif %}
