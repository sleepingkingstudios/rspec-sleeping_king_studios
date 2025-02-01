{% if include.definition.class_methods.size > 0 %}
<li>
  <a href="#class-methods">Class Methods</a>
  <ul style="margin-bottom: 0px;">
  {% for method in include.definition.class_methods %}
    <li><a href="#class-method-{{ method.slug | replace: "=", "--equals" | replace: "?", "--predicate" }}">{{ method.name }}</a></li>
  {% endfor %}
  </ul>
</li>
{% endif %}
