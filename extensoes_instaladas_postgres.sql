select name, default_version, installed_version, comment
from pg_available_extensions
order by name;
