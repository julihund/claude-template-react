Create a database migration using the create-db-migration agent.

Migration name from $ARGUMENTS (e.g., `/migrate add_user_preferences`).

The agent will:
1. Generate Alembic migration with `alembic revision --autogenerate -m "$ARGUMENTS"`
2. Review generated migration for safety issues
3. Add indexes for foreign keys and frequently queried columns
4. Test upgrade and downgrade locally
5. Validate migration is reversible and won't cause data loss

Provide the migration file path and summary of changes when complete.