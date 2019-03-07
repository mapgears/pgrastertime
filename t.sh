/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 0.25 0.25 -r near ./datatest/18g063120831_0025_depth.tiff /tmp/tmp2ioxex_j_0.25.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 0.5 0.5 -r max ./datatest/18g063120831_0025_depth.tiff /tmp/tmpqqkabd81_0.5.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 1 1 -r max ./datatest/18g063120831_0025_depth.tiff /tmp/tmpbkwhnyds_1.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 2 2 -r max ./datatest/18g063120831_0025_depth.tiff /tmp/tmp76rjshf7_2.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 4 4 -r max ./datatest/18g063120831_0025_depth.tiff /tmp/tmph28r5emd_4.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 8 8 -r max ./datatest/18g063120831_0025_depth.tiff /tmp/tmpv_ezg8ca_8.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 16 16 -r max ./datatest/18g063120831_0025_depth.tiff /tmp/tmpgyft7nff_16.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 0.25 0.25 -r near ./datatest/18g063120831_0025_density.tiff /tmp/tmpm3bfwfhs_0.25.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 0.5 0.5 -r sum ./datatest/18g063120831_0025_density.tiff /tmp/tmp34bn3_k5_0.5.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 1 1 -r sum ./datatest/18g063120831_0025_density.tiff /tmp/tmpc6_y36_g_1.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 2 2 -r sum ./datatest/18g063120831_0025_density.tiff /tmp/tmpinvi4i04_2.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 4 4 -r sum ./datatest/18g063120831_0025_density.tiff /tmp/tmp9pjonypv_4.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 8 8 -r sum ./datatest/18g063120831_0025_density.tiff /tmp/tmpn4cqz59f_8.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 16 16 -r sum ./datatest/18g063120831_0025_density.tiff /tmp/tmp0yg9oxxu_16.tiff
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 0.25 0.25 -r near ./datatest/18g063120831_0025_mean.tiff /tmp/tmpq4geqfxr_0.25.tiff
python gdal_calc.py -A /tmp/tmpm3bfwfhs_0.25.tiff -B /tmp/tmpq4geqfxr_0.25.tiff --calc='A*B' --outfile='/tmp/tmpmb4nub7i.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 0.5 0.5 -r sum /tmp/tmpmb4nub7i.tiff /tmp/tmpghrnp2pw.tiff
python gdal_calc.py -A /tmp/tmpghrnp2pw.tiff -B /tmp/tmpq4geqfxr_0.25.tiff --calc='A/B' --outfile='/tmp/tmplql3o2wr_0.5.tiff'
python gdal_calc.py -A /tmp/tmp34bn3_k5_0.5.tiff -B /tmp/tmplql3o2wr_0.5.tiff --calc='A*B' --outfile='/tmp/tmpsyorz19c.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 1 1 -r sum /tmp/tmpsyorz19c.tiff /tmp/tmpnxz_uv4x.tiff
python gdal_calc.py -A /tmp/tmpnxz_uv4x.tiff -B /tmp/tmplql3o2wr_0.5.tiff --calc='A/B' --outfile='/tmp/tmpo7r0lom__1.tiff'
python gdal_calc.py -A /tmp/tmpc6_y36_g_1.tiff -B /tmp/tmpo7r0lom__1.tiff --calc='A*B' --outfile='/tmp/tmptl39bsw4.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 2 2 -r sum /tmp/tmptl39bsw4.tiff /tmp/tmp7r2s8kwx.tiff
python gdal_calc.py -A /tmp/tmp7r2s8kwx.tiff -B /tmp/tmpo7r0lom__1.tiff --calc='A/B' --outfile='/tmp/tmp1at0sf3o_2.tiff'
python gdal_calc.py -A /tmp/tmpinvi4i04_2.tiff -B /tmp/tmp1at0sf3o_2.tiff --calc='A*B' --outfile='/tmp/tmpezlykhqc.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 4 4 -r sum /tmp/tmpezlykhqc.tiff /tmp/tmp_t3ru_c6.tiff
python gdal_calc.py -A /tmp/tmp_t3ru_c6.tiff -B /tmp/tmp1at0sf3o_2.tiff --calc='A/B' --outfile='/tmp/tmpdvobbuak_4.tiff'
python gdal_calc.py -A /tmp/tmp9pjonypv_4.tiff -B /tmp/tmpdvobbuak_4.tiff --calc='A*B' --outfile='/tmp/tmpfmrkbcdw.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 8 8 -r sum /tmp/tmpfmrkbcdw.tiff /tmp/tmph9ibr2fh.tiff
python gdal_calc.py -A /tmp/tmph9ibr2fh.tiff -B /tmp/tmpdvobbuak_4.tiff --calc='A/B' --outfile='/tmp/tmpl8qtsgkp_8.tiff'
python gdal_calc.py -A /tmp/tmpn4cqz59f_8.tiff -B /tmp/tmpl8qtsgkp_8.tiff --calc='A*B' --outfile='/tmp/tmp456ib6sb.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 16 16 -r sum /tmp/tmp456ib6sb.tiff /tmp/tmp__p_gsow.tiff
python gdal_calc.py -A /tmp/tmp__p_gsow.tiff -B /tmp/tmpl8qtsgkp_8.tiff --calc='A/B' --outfile='/tmp/tmpwsf54pvt_16.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 0.25 0.25 -r near ./datatest/18g063120831_0025_stddev.tiff /tmp/tmpua6kgzmj_0.25.tiff
python gdal_calc.py -A /tmp/tmpm3bfwfhs_0.25.tiff -B /tmp/tmpua6kgzmj_0.25.tiff --calc='(A-1)*B' --outfile='/tmp/tmpea0p3z7p.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 0.5 0.5 -r sum /tmp/tmpea0p3z7p.tiff /tmp/tmpycsnosrz.tiff
python gdal_calc.py -A /tmp/tmpycsnosrz.tiff -B /tmp/tmpq4geqfxr_0.25.tiff --calc='sqrt(A/(B-4)' --outfile='/tmp/tmpryytx9_b_0.5.tiff'
python gdal_calc.py -A /tmp/tmp34bn3_k5_0.5.tiff -B /tmp/tmpryytx9_b_0.5.tiff --calc='(A-1)*B' --outfile='/tmp/tmpz02m3ck_.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 1 1 -r sum /tmp/tmpz02m3ck_.tiff /tmp/tmpmjmkyaig.tiff
python gdal_calc.py -A /tmp/tmpmjmkyaig.tiff -B /tmp/tmplql3o2wr_0.5.tiff --calc='sqrt(A/(B-4)' --outfile='/tmp/tmpfqhhp_g1_1.tiff'
python gdal_calc.py -A /tmp/tmpc6_y36_g_1.tiff -B /tmp/tmpfqhhp_g1_1.tiff --calc='(A-1)*B' --outfile='/tmp/tmpxiuemt3y.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 2 2 -r sum /tmp/tmpxiuemt3y.tiff /tmp/tmpjj_fun35.tiff
python gdal_calc.py -A /tmp/tmpjj_fun35.tiff -B /tmp/tmpo7r0lom__1.tiff --calc='sqrt(A/(B-4)' --outfile='/tmp/tmp56elwwx2_2.tiff'
python gdal_calc.py -A /tmp/tmpinvi4i04_2.tiff -B /tmp/tmp56elwwx2_2.tiff --calc='(A-1)*B' --outfile='/tmp/tmpbsr3o9yq.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 4 4 -r sum /tmp/tmpbsr3o9yq.tiff /tmp/tmpz753ckst.tiff
python gdal_calc.py -A /tmp/tmpz753ckst.tiff -B /tmp/tmp1at0sf3o_2.tiff --calc='sqrt(A/(B-4)' --outfile='/tmp/tmpqk_m6vgt_4.tiff'
python gdal_calc.py -A /tmp/tmp9pjonypv_4.tiff -B /tmp/tmpqk_m6vgt_4.tiff --calc='(A-1)*B' --outfile='/tmp/tmpdyhuvuir.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 8 8 -r sum /tmp/tmpdyhuvuir.tiff /tmp/tmpio_y0gkx.tiff
python gdal_calc.py -A /tmp/tmpio_y0gkx.tiff -B /tmp/tmpdvobbuak_4.tiff --calc='sqrt(A/(B-4)' --outfile='/tmp/tmpyg27trx9_8.tiff'
python gdal_calc.py -A /tmp/tmpn4cqz59f_8.tiff -B /tmp/tmpyg27trx9_8.tiff --calc='(A-1)*B' --outfile='/tmp/tmp07wtrlg1.tiff'
/home/srvlocadm/gdal-2.4.0/apps/gdalwarp -t_srs EPSG:3979 -co COMPRESS=DEFLATE -tap -tr 16 16 -r sum /tmp/tmp07wtrlg1.tiff /tmp/tmpjs_qmsfj.tiff
python gdal_calc.py -A /tmp/tmpjs_qmsfj.tiff -B /tmp/tmpl8qtsgkp_8.tiff --calc='sqrt(A/(B-4)' --outfile='/tmp/tmphn1r8ce7_16.tiff'

