# core/management/commands/load_sql.py

from django.core.management.base import BaseCommand
from django.db import connection

class Command(BaseCommand):
    help = 'Load SQL files into the database'

    def handle(self, *args, **kwargs):
        sql_files = ['database/database.sql', 'database/populateDB.sql']
        for sql_file in sql_files:
            with open(sql_file, 'r') as file:
                sql = file.read()
            with connection.cursor() as cursor:
                cursor.execute(sql)
        self.stdout.write(self.style.SUCCESS('Successfully loaded SQL files'))
