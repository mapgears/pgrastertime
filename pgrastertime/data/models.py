import geoalchemy2, os, sys
import sqlalchemy as sa
from .sqla import Base
from pgrastertime import CONFIG
from pgrastertime.data.sqla import DBSession
from pgrastertime.processes import PostprocSQL


class PGRasterTime(Base):
    __tablename__ = "pgrastertime"

    id = sa.Column(sa.BigInteger, primary_key=True)
    tile_id = sa.Column(sa.BigInteger, nullable=False)
    raster = sa.Column(geoalchemy2.types.Raster, nullable=False)
    resolution = sa.Column(sa.Float, nullable=False)
    filename = sa.Column(sa.UnicodeText, nullable=True)
    sys_period = sa.Column(sa.dialects.postgresql.TSTZRANGE, nullable=False)
    
class Metadata(Base):
    __tablename__ = "metadata"    
    
    id = sa.Column(sa.BigInteger, primary_key=True)
    dunits = sa.Column(sa.UnicodeText, nullable=True)
    hordat = sa.Column(sa.UnicodeText, nullable=True)
    hunits = sa.Column(sa.UnicodeText, nullable=True)
    objnam = sa.Column(sa.UnicodeText, nullable=False)
    surath = sa.Column(sa.UnicodeText, nullable=True)
    surend = sa.Column(sa.UnicodeText, nullable=True)
    sursta = sa.Column(sa.UnicodeText, nullable=True)
    surtyp = sa.Column(sa.UnicodeText, nullable=True)
    tecsou = sa.Column(sa.UnicodeText, nullable=True)
    verdat = sa.Column(sa.UnicodeText, nullable=True)
    ch_typ = sa.Column(sa.UnicodeText, nullable=True)
    client = sa.Column(sa.UnicodeText, nullable=True)
    cretim = sa.Column(sa.UnicodeText, nullable=True)
    glocat = sa.Column(sa.UnicodeText, nullable=True)
    hcosys = sa.Column(sa.UnicodeText, nullable=True)
    idprnt = sa.Column(sa.UnicodeText, nullable=True)
    km_end = sa.Column(sa.UnicodeText, nullable=True)
    kmstar = sa.Column(sa.UnicodeText, nullable=True)
    lwschm = sa.Column(sa.UnicodeText, nullable=True)
    modtim = sa.Column(sa.UnicodeText, nullable=True)
    planam = sa.Column(sa.UnicodeText, nullable=True)
    plocat = sa.Column(sa.UnicodeText, nullable=True)
    prjtyp = sa.Column(sa.UnicodeText, nullable=True)
    srcfil = sa.Column(sa.UnicodeText, nullable=True)
    srfcat = sa.Column(sa.UnicodeText, nullable=True)
    srfdsc = sa.Column(sa.UnicodeText, nullable=True)
    srfres = sa.Column(sa.UnicodeText, nullable=True)
    srftyp = sa.Column(sa.UnicodeText, nullable=True)
    sursso = sa.Column(sa.UnicodeText, nullable=True)
    uidcre = sa.Column(sa.UnicodeText, nullable=True)

class SpatialRefSys(Base):
    __tablename__ = 'spatial_ref_sys'

    srid = sa.Column(sa.INTEGER(), autoincrement=False,
                     nullable=False, primary_key=True)
    auth_name = sa.Column(sa.VARCHAR(length=256),
                          autoincrement=False, nullable=True)
    auth_srid = sa.Column(sa.INTEGER(), autoincrement=False, nullable=True)
    srtext = sa.Column(sa.VARCHAR(length=2048), autoincrement=False,
                       nullable=True)
    proj4text = sa.Column(sa.VARCHAR(length=2048), autoincrement=False,
                          nullable=True)
                          
class SQLModel():

    def __init__(self, tablename):
        self.tablename = tablename
        
    def setPgrastertimeTableStructure(target_name):
        # strucure table can be customized by user and are stored in ./sql folder
        pgrast_table = CONFIG['app:main'].get('db.pgrastertable') 
        pgrast_file = os.path.dirname(os.path.realpath(sys.argv[0])) + pgrast_table
        with open(pgrast_file) as f:
            pgrast_sql = f.readlines()
            pgrast_target_table = ''.join(pgrast_sql).replace('pgrastertime',target_name)
        try:
            DBSession().execute("DROP TABLE IF EXISTS " + args.tablename)
            DBSession().execute(pgrast_target_table)
            DBSession().commit()
        except:
            print("Fail to rebuild pgrastertime target table")

    def setMetadataeTableStructure(target_name):
        # strucure table can be customized by user and are stored in ./sql folder
        meta_table = CONFIG['app:main'].get('db.metadatatable') 
        meta_file = os.path.dirname(os.path.realpath(sys.argv[0])) + meta_table
        with open(meta_file) as f:
            meta_sql = f.readlines()
            mate_target_table = ''.join(meta_sql).replace('metadata',target_name + '_metadata')
        try:
            DBSession().execute("DROP TABLE IF EXISTS " + args.tablename + "_metadata")
            DBSession().execute(mate_target_table)
            DBSession().commit()
        except:
            print("Fail to rebuild metadata target table")

    def deployPgrastertimeTable(root,tablename):
           
           deploy_script = root + \
                           CONFIG['app:main'].get('db.sqlpath') + "/deploy.sql"
           PostprocSQL(deploy_script,tablename).execute()
     
