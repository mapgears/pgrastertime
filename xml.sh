echo "create temporary table  metadatatemp as SELECT xml " > ins.sql
echo "\$\$ " >> ins.sql
cat $1 >> ins.sql
echo "\$\$  AS objectXml;" >> ins.sql
sed -i '3d' ins.sql
echo "INSERT INTO $2_metadata 
  SELECT xmltable.*
  FROM metadatatemp,
  XMLTABLE ('//BDB_Simple_Attributes' PASSING objectXml
  COLUMNS
  DUNITS text PATH  'Attribute[@name = \"DUNITS\"]/Value',
  HORDAT text PATH  'Attribute[@name = \"HORDAT\"]/Value',
  HUNITS text PATH  'Attribute[@name = \"HUNITS\"]/Value',
  OBJNAM text PATH  'Attribute[@name = \"OBJNAM\"]/Value',
  SURATH text PATH  'Attribute[@name = \"SURATH\"]/Value',
  SUREND text PATH  'Attribute[@name = \"SUREND\"]/Value',
  SURSTA text PATH  'Attribute[@name = \"SURSTA\"]/Value',
  SURTYP text PATH  'Attribute[@name = \"SURTYP\"]/Value',
  TECSOU text PATH  'Attribute[@name = \"TECSOU\"]/Value',
  VERDAT text PATH  'Attribute[@name = \"VERDAT\"]/Value',
  ch_typ text PATH  'Attribute[@name = \"ch_typ\"]/Value',
  client text PATH  'Attribute[@name = \"client\"]/Value',
  cretim text PATH  'Attribute[@name = \"cretim\"]/Value',
  glocat text PATH  'Attribute[@name = \"glocat\"]/Value',
  hcosys text PATH  'Attribute[@name = \"hcosys\"]/Value',
  idprnt text PATH  'Attribute[@name = \"idprnt\"]/Value',
  km_end text PATH  'Attribute[@name = \"km_end\"]/Value',
  kmstar text PATH  'Attribute[@name = \"kmstar\"]/Value',
  lwschm text PATH  'Attribute[@name = \"lwschm\"]/Value',
  modtim text PATH  'Attribute[@name = \"modtim\"]/Value',
  planam text PATH  'Attribute[@name = \"planam\"]/Value',
  plocat text PATH  'Attribute[@name = \"plocat\"]/Value',
  prjtyp text PATH  'Attribute[@name = \"prjtyp\"]/Value',
  srcfil text PATH  'Attribute[@name = \"srcfil\"]/Value',
  srfcat text PATH  'Attribute[@name = \"srfcat\"]/Value',
  srfdsc text PATH  'Attribute[@name = \"srfdsc\"]/Value',
  srfres text PATH  'Attribute[@name = \"srfres\"]/Value',
  srftyp text PATH  'Attribute[@name = \"srftyp\"]/Value',
  sursso text PATH  'Attribute[@name = \"sursso\"]/Value',
  uidcre text PATH  'Attribute[@name = \"uidcre\"]/Value');
">>ins.sql