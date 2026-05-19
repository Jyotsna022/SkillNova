# SkillNova Database Setup

## Target
MySQL 8.x

## Steps (MySQL Workbench)
1. Open MySQL Workbench and connect to your local MySQL server.
2. Open the SQL editor tab.
3. Open and run `database/schema.sql`.
4. Refresh schemas and confirm a schema named `skillnova` exists.
5. Expand `skillnova > Tables` and verify all tables were created.

## Quick verification queries
```sql
USE skillnova;
SHOW TABLES;
SELECT * FROM roles;
```

Expected roles:
- ADMIN
- CLIENT
- FREELANCER

## Notes
- The schema includes unique constraints, foreign keys, and checks aligned to coursework requirements.
- We can generate ERD from this schema in Workbench once you confirm successful execution.
- Database connection is currently configured in `src/main/java/com/skillnova/util/DBConnection.java`.
