@echo off

psql -U postgres -d vendas -f load_full.sql

echo =====================================
echo PROCESSO FINALIZADO
echo =====================================
pause