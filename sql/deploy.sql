SELECT dfo_deploy('wis','pgrastertime');
SELECT dfo_invalidate('wis','pgrastertime','TRUE');
SELECT dfo_update_most_recent_tables('wis','pgrastertime');
