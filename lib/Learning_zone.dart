import 'package:SignEase/Week%201/learnalphabet.dart';
import 'package:SignEase/Week%201/learnnumbers.dart';
import 'package:SignEase/Week%202/learngreeting.dart';
import 'package:SignEase/Week%202/learnrelations.dart';
import 'package:SignEase/Week%203/learnnoun.dart';
import 'package:SignEase/Week%203/learnpronoun.dart';
import 'package:SignEase/Week%203/learnverbs.dart';
import 'package:SignEase/Week 4/Simple_Sentence_Formation_using_Videos/learnpage_videos.dart';
import 'package:SignEase/leaderboard.dart';
import 'package:SignEase/searched_video_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Bonus_Week/Learn_Operators.dart';

class LearningZone extends StatefulWidget {
  const LearningZone({super.key});

  @override
  State<LearningZone> createState() => _LearningZoneState();
}

class _LearningZoneState extends State<LearningZone> {
  String username = 'Loading...';
  final TextEditingController _searchController = TextEditingController();

  final Map<String, String> allWords = {
    'A':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/A-labelled_sed7ad.png',
    'B':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/B-labelled_jppjzn.png',
    'C':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/C-labelled_h4kxsi.png',
    'D':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/D-labelled_sbsek7.png',
    'E':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/E-labelled_bovjls.png',
    'F':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/F-labelled_kxce14.png',
    'G':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/G-labelled_oxmqrx.png',
    'H':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355181/H-labelled_lbiwjc.png',
    'I (Alphabet)':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/I-labelled_p4zjxd.png',
    'J':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/J-labelled_k4o6y3.png',
    'K':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/K-labelled_ti6ypj.png',
    'L':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/L-labelled_vuydr9.png',
    'M':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355182/M-labelled_bsovuc.png',
    'N':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355183/N-labelled_p8wypu.png',
    'O':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355183/O-labelled_lhvsun.png',
    'P':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/P-labelled_fzfe3d.png',
    'Q':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/Q-labelled_gvyepx.png',
    'R':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355198/R-labelled_fxi6de.png',
    'S':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/S-labelled_fjph3z.png',
    'T':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355199/T-labelled_blzhjl.png',
    'U':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/U-labelled_blgp2r.png',
    'V':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/V-labelled_rndws0.png',
    'W':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/W-labelled_lpl5ga.png',
    'X':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/X-labelled_bk8rem.png',
    'Y':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355204/Y-labelled_najbm5.png',
    'Z':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1730355180/Z-labelled_g2fqxi.png',
    '0':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468140/0_num_hzxxvg.png',
    '1':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468141/1_num_exnnlu.png',
    '2':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468143/2_num_tb62qp.png',
    '3':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468140/3_num_qb0ovx.png',
    '4':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468141/4_num_vbwkaj.png',
    '5':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468142/5_num_c2sbks.png',
    '6':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468143/6_num_rygxkv.png',
    '7':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468144/7_num_iblbw8.png',
    '8':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468144/8_num_qm8gci.png',
    '9':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468139/9_num_cpzgzn.png',
    '10':
        'https://res.cloudinary.com/dfph32nsq/image/upload/v1728468139/10_num_k0k0h7.png',
    'Girl Child':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730267226/girl_child_size_reduced_ai2wft.mp4',
    'Daughter':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730267226/girl_child_size_reduced_ai2wft.mp4',
    'Female Person':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731604294/Female_Person_Compound_eosq00.mp4',
    'Women':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731604294/Female_Person_Compound_eosq00.mp4',
    'Good Morning':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730267228/good_morning_size_reduced_xdlcs7.mp4',
    'Good Afternoon':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730267224/good_afternoon_size_reduced_koudti.mp4',
    'Good Night':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730186218/Good_Night_simple_asxfpe.mp4',
    'See You Again':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113629/see_you_again_pq2rok.mp4',
    'See You Tomorrow':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113636/see_you_tomorrow_kkhlel.mp4',
    'Whats_up':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734887485/What_s_Up_labelled_bwix9k.mp4',
    'Baby':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125689/baby_m5j2ml.mp4',
    'Mother':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125682/mother_xsdqsk.mp4',
    'Father':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125688/father_shv0s8.mp4',
    'Brother':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125688/brother_zrrtqr.mp4',
    'Sister':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125684/sister_bxolqx.mp4',
    'People':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125684/people_jjw2bk.mp4',
    'Friend':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125682/friend_kjbxg8.mp4',
    'Man':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730125683/man_vy9lea.mp4',
    'grand_mother':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734888126/grandmother_labelled_cv8wrg.mp4',
    'grand_daughter':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734888120/granddaughter_labelled_csxpvw.mp4',
    'grand_son':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734888120/grandson_labelled_eonjnt.mp4',
    'grand_father':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734888119/grandfather_labelled_xcsrat.mp4',
    'uncle':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734888120/uncle_labelled_uzy4fk.mp4',
    'aunt':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734888119/aunt_labelled_nmlweo.mp4',
    'nephew':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734888126/nephew_labelled_kqravp.mp4',
    'niece':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734888122/niece_labelled_auxqyu.mp4',
    'Hello':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113628/hello_q0jqlg.mp4',
    'Hy':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113627/hy_ewk653.mp4',
    'Hi':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113627/hy_ewk653.mp4',
    'Good Bye':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113628/good_bye_fdlupb.mp4',
    'Namaste':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113630/namaste_ywacpg.mp4',
    'Welcome':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730113634/welcome_rnwqkq.mp4',
    'Book':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558926/book_l_eike3i.mp4',
    'School':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558925/school_l_t98bdl.mp4',
    'Lunch':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558924/lunch_l_z6h5il.mp4',
    'Hands':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558924/hands_l_pvatyv.mp4',
    'Morning':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558922/morning_l_x5lnsf.mp4',
    'Deaf':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558921/deaf_l_k2eicr.mp4',
    'Tea':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558920/tea_l_oetesc.mp4',
    'Office':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558920/office_l_svsjwl.mp4',
    'Breakfast':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558921/breakfast_l_udba1y.mp4',
    'Dinner':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558922/dinner_l_zlsyq2.mp4',
    'Market':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558922/market_l_sdnjwt.mp4',
    'Work':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558921/work_l_bpj6jp.mp4',
    'Home':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410106/Home_labelled_poqrcy.mp4',
    'Aeroplane':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410106/Aeroplane_labelled_wolg5v.mp4',
    'Fish':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410107/Fish_labelled_rp6asv.mp4',
    'Student':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410107/Student_labelled_otumhu.mp4',
    'Teacher':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410108/Teacher_labelled_q1bvpw.mp4',
    'India':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410108/India_labelled_e7hc14.mp4',
    'Birds':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410116/Birds_labelled_v8ajkw.mp4',
    'Egg':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891814/egg_labelled_rbsv4f.mp4',
    'Floor':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891814/floor_labelled_fjthev.mp4',
    'Moon':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891815/moon_labelled_byw2uu.mp4',
    'Water':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891815/water_labelled_jvqbfn.mp4',
    'Table':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891816/table_labelled_etlhjx.mp4',
    'Tree':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891816/tree_labelled_hv7mof.mp4',
    'Bus':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891817/bus_labelled_a7licg.mp4',
    'Car':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891818/car_labelled_cnxsxu.mp4',
    'Cricket':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891820/cricket_labelled_angypw.mp4',
    'Flower':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891821/flower_labelled_tunlpp.mp4',
    'Shirt':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891822/shirt_labelled_hjsiqp.mp4',
    'Chair':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891823/chair_labelled_n5xjbi.mp4',
    'Shoes':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891823/shoes_labelled_wutejf.mp4',
    'Coffee':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891824/office_labelled_fs8b2y.mp4',
    'Sun':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891825/sun_labelled_hzawsr.mp4',
    'Mirror':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891827/mirror_labelled_gpodlh.mp4',
    'Garden':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891828/garden_labelled_ksjalq.mp4',
    'Train':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891830/train_labelled_xm0azf.mp4',
    'Delhi':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891829/Delhi_labelled_cd9nuv.mp4',
    'Football':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734891832/football_labelled_prpmvf.mp4',
    'I (Pronoun)':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558959/I_l_yyecwh.mp4',
    'You':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558961/you_l_azwpnx.mp4',
    'He':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558958/he_l_baxnwe.mp4',
    'She':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558962/she_l_c43uu8.mp4',
    'It':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558956/it_l_qc8pzw.mp4',
    'We':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558969/we_l_wbytyb.mp4',
    'They':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558957/they_l_hgsvu0.mp4',
    'My':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731410342/My_labelled_a5i37x.mp4',
    'Come':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/come_l_xxndp7.mp4',
    'Eat':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/eat_l_kqflhk.mp4',
    'Drink':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/drink_l_qcxtet.mp4',
    'Read':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/read_l_pdsx7g.mp4',
    'Write':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558847/write_l_i7jrlt.mp4',
    'Sleep':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/sleep_l_wej9uh.mp4',
    'Walk':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558851/walk_l_urzxqn.mp4',
    'Talk':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558849/talk_l_zurskm.mp4',
    'Wake Up':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558849/wake_up_l_o1upds.mp4',
    // ignore: equal_keys_in_map
    'Work':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558849/work_l_ik2ynw.mp4',
    'Finish':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558848/finish_l_vl1692.mp4',
    'Use':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730558849/use_l_nwwifk.mp4',
    'Cook':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1730559387/cook_l_tao1wz.mp4',
    'Wash':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409737/Wash_labelled_jvhgir.mp4',
    'Fly':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890135/fly__labelled_j9xcbb.mp4',
    'Give':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409738/Give_labelled_n99bii.mp4',
    'Catch':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890133/catch_labelled_p3cske.mp4',
    'Cry':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890134/cry_labelled_imopdy.mp4',
    'Wear':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890135/wear_labelled_hq6leo.mp4',
    'Grow':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890136/grow_labelled_kfenxp.mp4',
    'Drive':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890137/drive_labelled_ucmbgh.mp4',
    'Sing':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890137/sing_labelled_x6vmao.mp4',
    'Clean':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890138/clean_labelled_odui5v.mp4',
    'Wait':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890138/wait_labelled_apa5d1.mp4',
    'Jump':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890138/jump_labelled_djtf90.mp4',
    'Listen':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890139/listen_labelled_oqridg.mp4',
    'Sit':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890139/sit_labelled_qjmkel.mp4',
    'Think':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890139/think_labelled_s6wwuc.mp4',
    'Stand':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890139/stand_labelled_eqp833.mp4',
    'Meet':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890139/meet_labelled_gumy3r.mp4',
    'Dance':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890140/dance_labelled_esqtcb.mp4',
    'Run':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890140/run_labelled_yc8zzk.mp4',
    'Play':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890141/play_labelled_mqufuu.mp4',
    'Smile':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890140/smile_labelled_il8qfa.mp4',
    'Draw':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890141/draw_labelled_kphqz2.mp4',
    'Travel':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890144/travel_labelled_txpf7d.mp4',
    'Teach':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409737/Teach_labelled_urxibn.mp4',
    'Swim':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1734890142/swim_labelled_mkv4nm.mp4',
    'Live':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/Live_labelled_im0cj3.mp4',
    'Love':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/Love_labelled_flwjac.mp4',
    'See':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/See_labelled_vbmmjz.mp4',
    'Go':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409740/Go_labelled_crsq3i.mp4',
    'Look':
        'https://res.cloudinary.com/dfph32nsq/video/upload/v1731409741/Look_labelled_xp94zn.mp4',
    'Mother is cooking dinner':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839165/5_nvihuh.mp4',
    'We are drinking tea':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839166/12_f6ehlr.mp4',
    'Brother is talking with sister':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839167/7_frbowk.mp4',
    'Father has come to house':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839167/6_ceztqd.mp4',
    'We go to market':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839168/2_ruo2xg.mp4',
    'I write book':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839168/1_yo1wdo.mp4',
    'They work in office':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839158/3_imckgt.mp4',
    'I talk to friends':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839159/24_rgdnba.mp4',
    'I Live in a house':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839165/17_giamsf.mp4',
    'They look at birds':
        'https://res.cloudinary.com/dz3zoiak2/video/upload/v1731839165/20_logbq8.mp4',
  };

  List<MapEntry<String, String>> filteredWords = [];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _getUsername();
    _pageController = PageController(viewportFraction: 0.9);
    _searchController.addListener(filterSuggestions);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void filterSuggestions() {
    final query = _searchController.text
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .toLowerCase();

    setState(() {
      filteredWords = query.isEmpty
          ? []
          : allWords.entries
              .where((entry) => entry.key.toLowerCase().startsWith(query))
              .toList()
        ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

      if (filteredWords.isEmpty && query.isNotEmpty) {
        filteredWords.add(MapEntry("Not exist", ""));
      }
    });
  }

  Future<void> _getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          username = userDoc.exists ? (userDoc['name'] ?? 'User') : 'User';
        });
      } catch (e) {
        setState(() {
          username = 'Error fetching username';
        });
        print('Error fetching username: $e');
      }
    } else {
      setState(() {
        username = 'No User';
      });
    }
  }

  Widget buildCustomCard({
    required ImageProvider image,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image section
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: Stack(
                  children: [
                    Image(
                      image: image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text buildBoldText(String text, String query) {
    int startIndex = text.toLowerCase().indexOf(query.toLowerCase());
    if (startIndex != -1) {
      String match = text.substring(startIndex, startIndex + query.length);
      String beforeMatch = text.substring(0, startIndex);
      String afterMatch = text.substring(startIndex + query.length);
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: beforeMatch),
            TextSpan(
                text: match, style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: afterMatch),
          ],
        ),
      );
    } else {
      return Text(text); // Return regular text if no match
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 233, 215),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting and Search Bar
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: screenWidth * 0.06,
          color: Colors.black,
        ),
        children: <TextSpan>[
          const TextSpan(text: "Hi "),
          TextSpan(
            text: username,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.06,
              color: const Color(0xFF1E1E1E),
            ),
          ),
          const TextSpan(text: " !"),
        ],
      ),
    ),
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeaderBoard(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFC107), Color(0xFFFF8C00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: const [
            Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              "LeaderBoard",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),

                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(255, 224, 118, 30),
                            const Color.fromARGB(255, 230, 136, 23),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: screenWidth * 0.05,
                            offset: Offset(0, screenHeight * 0.02),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.06),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reviewing Zone',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.07,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.4),
                                          blurRadius: screenWidth * 0.02,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.015),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.008,
                                        horizontal: screenWidth * 0.03),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.02),
                                    ),
                                    child: Text(
                                      'Learn Indian Sign Language with ease!',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.05,
                            ),
                            SizedBox(
                              width: screenHeight * 0.1,
                              height: screenHeight * 0.1,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.grey.shade300,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.05),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0),
                                      blurRadius: screenWidth * 0.04,
                                      offset: Offset(0, screenHeight * 0.015),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.05),
                                  child: Image.asset(
                                    'images/childisl.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.023),
                  TextField(
                    controller: _searchController,
                    cursorColor: Colors.orange,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Type Word/Sentence to search ...",
                      hintStyle:
                          const TextStyle(color: Colors.black54, fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 238, 126, 34),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 255, 184, 95),
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          String query = _searchController.text.trim();
                          if (query.isNotEmpty) {
                            // Navigate to Search_Video_Screen with the search query and corresponding link
                            final entry = filteredWords.firstWhere(
                              (entry) => entry.key
                                  .toLowerCase()
                                  .startsWith(query.toLowerCase()),
                              orElse: () => MapEntry('', ''),
                            );
                            if (entry.key.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Search_Video_Screen(
                                    word: entry.key,
                                    link: entry.value,
                                  ),
                                ),
                              );
                            }
                            _searchController.clear();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 238, 126, 34),
                                Color.fromARGB(255, 255, 184, 95),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search,
                              color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  // Suggestions Box
                  if (filteredWords.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredWords.length,
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                          indent: 15,
                          endIndent: 15,
                        ),
                        itemBuilder: (context, index) {
                          final word = filteredWords[index].key;
                          final link = filteredWords[index].value;
                          return ListTile(
                            title: Text(
                              word,
                              style: const TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Search_Video_Screen(
                                      word: word, link: link),
                                ),
                              ).then((_) {
                                _searchController.clear();
                                filterSuggestions();
                              });
                            },
                          );
                        },
                      ),
                    ),

                  SizedBox(height: screenHeight * 0.005),
                  SizedBox(
                    height: screenHeight * 0.35,
                    child: PageView.builder(
                      controller:
                          _pageController, // Ensure _pageController is initialized in your StatefulWidget
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double value = 0.0;
                            if (_pageController.position.haveDimensions) {
                              value = index - _pageController.page!;
                              value = (1 - value.abs() * 0.3).clamp(0.8, 1.0);
                            }

                            return GestureDetector(
                              onTap: () {
                                // Implement navigation or functionality for each card here
                                switch (index) {
                                  case 0:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LearnAlphabet()),
                                    );
                                    break;
                                  case 1:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LearnNumbers()),
                                    );
                                    break;
                                  case 2:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IslMathLearningPage()),
                                    );
                                    break;
                                  case 3:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LearnGreetings()),
                                    );
                                    break;
                                  case 4:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LearnRelations()),
                                    );
                                    break;
                                  case 5:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LearnVerbs()),
                                    );
                                    break;
                                  case 6:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LearnNouns()),
                                    );
                                    break;
                                  case 7:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LearnPronouns()),
                                    );
                                    break;
                                  case 8:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Learn_Simple_Sentence()),
                                    );
                                    break;
                                }
                              },
                              child: Transform(
                                transform: Matrix4.identity()
                                  ..scale(value)
                                  ..rotateY(
                                      (index - (_pageController.page ?? 0)) *
                                          0.1),
                                alignment: Alignment.center,
                                child: buildCustomCard(
                                  image: AssetImage(
                                    index == 0
                                        ? 'images/alphabets.jpg'
                                        : index == 1
                                            ? 'images/numbers.jpg'
                                            : index == 2
                                                ? 'images/maths.png'
                                                : index == 3
                                                    ? 'images/greetings.png'
                                                    : index == 4
                                                        ? 'images/Relation.jpg'
                                                        : index == 5
                                                            ? 'images/verbs.png'
                                                            : index == 6
                                                                ? 'images/nouns.png'
                                                                : index == 7
                                                                    ? 'images/pronouns.png'
                                                                    : 'images/sentence_struct.png',
                                  ),
                                  title: index == 0
                                      ? 'Review Signing Alphabets'
                                      : index == 1
                                          ? 'Review Signing Numbers'
                                          : index == 2
                                              ? 'Basic Maths Operations'
                                              : index == 3
                                                  ? 'Review Signing Greetings'
                                                  : index == 4
                                                      ? 'Review Signing Relations'
                                                      : index == 5
                                                          ? 'Review Signing Verbs'
                                                          : index == 6
                                                              ? 'Review Signing Nouns'
                                                              : index == 7
                                                                  ? 'Review Signing Pronouns'
                                                                  : 'Review Basic Sentence Structure',
                                  onTap: () {
                                    // Ensure the onTap logic is passed correctly
                                    switch (index) {
                                      case 0:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LearnAlphabet()),
                                        );
                                        break;
                                      case 1:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LearnNumbers()),
                                        );
                                        break;
                                      case 2:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IslMathLearningPage()),
                                        );
                                        break;
                                      case 3:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LearnGreetings()),
                                        );
                                        break;
                                      case 4:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LearnRelations()),
                                        );
                                        break;
                                      case 5:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LearnVerbs()),
                                        );
                                        break;
                                      case 6:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LearnNouns()),
                                        );
                                        break;
                                      case 7:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LearnPronouns()),
                                        );
                                        break;
                                      case 8:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Learn_Simple_Sentence()),
                                        );
                                        break;
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
