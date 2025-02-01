{% if include.definition.constants.size > 0 %}
<li>
  <a href="#constants">Constants</a>
  <ul style="margin-bottom: 0px;">
  {% for constant in include.definition.constants %}
    <li><a href="#constant-{{ constant.slug }}">{{ constant.name }}</a></li>
  {% endfor %}
  </ul>
</li>
{% endif %}
