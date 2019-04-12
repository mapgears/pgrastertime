--Insertion des raster dans les tables partitionné
INSERT INTO xsoundings(tile_id,rast,resolution,filename,sys_period,tile_extent,tile_geom,metadata_id,shoal_geom)
SELECT tile_id,raster,resolution,filename,sys_period,tile_extent,tile_geom,metadata_id,shoal_geom 
FROM pgrastertime;

--insetion des metadata 
INSERT INTO metadata (dunits, hordat, hunits, objnam, surath, surend, sursta, surtyp, tecsou, verdat, ch_typ, client, cretim, glocat, hcosys, idprnt, km_end, kmstar, lwschm, modtim, planam, plocat, prjtyp, srcfil, srfcat, srfdsc, srfres, srftyp, sursso, uidcre) 
SELECT dunits, hordat, hunits, objnam, surath, surend, sursta, surtyp, tecsou, verdat, ch_typ, client, cretim, glocat, hcosys, idprnt, km_end, kmstar, lwschm, modtim, planam, plocat, prjtyp, srcfil, srfcat, srfdsc, srfres, srftyp, sursso, uidcre
FROM  pgrasertime_metadata	 
 ON CONFLICT (objnam) 
DO NOTHING;
