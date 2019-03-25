set -e

echo "Running migrations"
bin/shortify eval "Elixir.Core.ReleaseTasks.migrate"
echo "Migrations run successfully"
