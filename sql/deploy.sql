SELECT dfo_update_soundings_tables('pgrastertime');
SELECT dfo_invalidate( 'pgrastertime','TRUE' );
SELECT dfo_update_most_recent_tables('pgrastertime');
