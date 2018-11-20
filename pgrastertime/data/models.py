import geoalchemy2
import sqlalchemy as sa
from .sqla import Base


class PGRasterTime(Base):
    __tablename__ = "pgrastertime"

    id = sa.Column(sa.BigInteger, primary_key=True)
    tile_id = sa.Column(sa.BigInteger, nullable=False)
    raster = sa.Column(geoalchemy2.types.Raster, nullable=False)
    resolution = sa.Column(sa.Float, nullable=False)
    filename = sa.Column(sa.UnicodeText, nullable=True)


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
