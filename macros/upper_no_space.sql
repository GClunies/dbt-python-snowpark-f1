{% macro upper_no_space(column) %}

    upper(replace({{ column }}, ' ', '_'))

{% endmacro %}
