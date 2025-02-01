{% if include.definition.instance_methods.size > 0 %}
<li>
  <a href="#instance-methods">Instance Methods</a>
  <ul style="margin-bottom: 0px;">
  {% for method in include.definition.instance_methods %}
    <li><a href="#instance-method-{{ method.slug | replace: "=", "--equals" | replace: "?", "--predicate" }}">{{ method.name }}</a></li>
  {% endfor %}
  </ul>
</li>
{% endif %}
