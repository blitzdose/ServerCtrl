'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "5811b5bf1d0624a8d95a9b615cdcc4db",
"assets/AssetManifest.bin.json": "15dccbf8cf9e9297efd464ccb5bdb83d",
"assets/AssetManifest.json": "ea80496c61eb464126fbe5e7a9a42e66",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "37e40bf159198b53f1e2f75f4e0ccbf3",
"assets/NOTICES": "804d4f7af0d8cd1427d3169dc44d502e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "1b5634953f2674404ac41a77135a0357",
"assets/packages/flutter_localized_locales/data/af.json": "3b7f153d0c2d08a03549973173d57436",
"assets/packages/flutter_localized_locales/data/af_NA.json": "3b7f153d0c2d08a03549973173d57436",
"assets/packages/flutter_localized_locales/data/af_ZA.json": "3b7f153d0c2d08a03549973173d57436",
"assets/packages/flutter_localized_locales/data/ak.json": "0bc78c4c9cb9aa5b6419745fbc90c016",
"assets/packages/flutter_localized_locales/data/ak_GH.json": "0bc78c4c9cb9aa5b6419745fbc90c016",
"assets/packages/flutter_localized_locales/data/am.json": "c05e0c9446268fb9bd92e505b828c13b",
"assets/packages/flutter_localized_locales/data/am_ET.json": "c05e0c9446268fb9bd92e505b828c13b",
"assets/packages/flutter_localized_locales/data/ar.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_AE.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_BH.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_DJ.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_DZ.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_EG.json": "da14619c6cad4a4b6b6aa6436785e504",
"assets/packages/flutter_localized_locales/data/ar_EH.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_ER.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_IL.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_IQ.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_JO.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_KM.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_KW.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_LB.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_LY.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_MA.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_MR.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_OM.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_PS.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_QA.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_SA.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_SD.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_SO.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_SS.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_SY.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_TD.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_TN.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/ar_YE.json": "025299c082a269d8f169cf25d11d0e7e",
"assets/packages/flutter_localized_locales/data/as.json": "2339fe85ab9d9029a5df7c65e8f2cdf5",
"assets/packages/flutter_localized_locales/data/as_IN.json": "2339fe85ab9d9029a5df7c65e8f2cdf5",
"assets/packages/flutter_localized_locales/data/az.json": "1ec1ba6d72a4ede43cabb49b89882cd1",
"assets/packages/flutter_localized_locales/data/az_AZ.json": "1ec1ba6d72a4ede43cabb49b89882cd1",
"assets/packages/flutter_localized_locales/data/az_Cyrl.json": "d50b3fe67ce4aa32414257dc5e70f58b",
"assets/packages/flutter_localized_locales/data/az_Cyrl_AZ.json": "d50b3fe67ce4aa32414257dc5e70f58b",
"assets/packages/flutter_localized_locales/data/az_Latn.json": "1ec1ba6d72a4ede43cabb49b89882cd1",
"assets/packages/flutter_localized_locales/data/az_Latn_AZ.json": "1ec1ba6d72a4ede43cabb49b89882cd1",
"assets/packages/flutter_localized_locales/data/be.json": "77bd40cce877ce67a6b5fb18c5344df7",
"assets/packages/flutter_localized_locales/data/be_BY.json": "77bd40cce877ce67a6b5fb18c5344df7",
"assets/packages/flutter_localized_locales/data/bg.json": "fd590379fa7290042789e7a357e9b9c6",
"assets/packages/flutter_localized_locales/data/bg_BG.json": "fd590379fa7290042789e7a357e9b9c6",
"assets/packages/flutter_localized_locales/data/bm.json": "7d8251fbbb46c6f8692e4cb4b556366b",
"assets/packages/flutter_localized_locales/data/bm_Latn.json": "7d8251fbbb46c6f8692e4cb4b556366b",
"assets/packages/flutter_localized_locales/data/bm_Latn_ML.json": "7d8251fbbb46c6f8692e4cb4b556366b",
"assets/packages/flutter_localized_locales/data/bn.json": "15331faaa760ff0813411f4d51d20528",
"assets/packages/flutter_localized_locales/data/bn_BD.json": "15331faaa760ff0813411f4d51d20528",
"assets/packages/flutter_localized_locales/data/bn_IN.json": "1d363c9639ac5041d6418997ca486564",
"assets/packages/flutter_localized_locales/data/bo.json": "0445a0d4e1399d30aa2ea49bb24f47d8",
"assets/packages/flutter_localized_locales/data/bo_CN.json": "0445a0d4e1399d30aa2ea49bb24f47d8",
"assets/packages/flutter_localized_locales/data/bo_IN.json": "0445a0d4e1399d30aa2ea49bb24f47d8",
"assets/packages/flutter_localized_locales/data/br.json": "7d9dc7b1614ba7dc74a2824fc53ff6c2",
"assets/packages/flutter_localized_locales/data/br_FR.json": "7d9dc7b1614ba7dc74a2824fc53ff6c2",
"assets/packages/flutter_localized_locales/data/bs.json": "f00ca4d2d1623fb6e2899e7317576d06",
"assets/packages/flutter_localized_locales/data/bs_BA.json": "f00ca4d2d1623fb6e2899e7317576d06",
"assets/packages/flutter_localized_locales/data/bs_Cyrl.json": "0da8b43d1749215cae4a64468222576b",
"assets/packages/flutter_localized_locales/data/bs_Cyrl_BA.json": "0da8b43d1749215cae4a64468222576b",
"assets/packages/flutter_localized_locales/data/bs_Latn.json": "f00ca4d2d1623fb6e2899e7317576d06",
"assets/packages/flutter_localized_locales/data/bs_Latn_BA.json": "f00ca4d2d1623fb6e2899e7317576d06",
"assets/packages/flutter_localized_locales/data/ca.json": "316556663b11ec3418947eeb984b0346",
"assets/packages/flutter_localized_locales/data/ca_AD.json": "316556663b11ec3418947eeb984b0346",
"assets/packages/flutter_localized_locales/data/ca_ES.json": "316556663b11ec3418947eeb984b0346",
"assets/packages/flutter_localized_locales/data/ca_FR.json": "316556663b11ec3418947eeb984b0346",
"assets/packages/flutter_localized_locales/data/ca_IT.json": "316556663b11ec3418947eeb984b0346",
"assets/packages/flutter_localized_locales/data/cs.json": "0e530a7012340fe2b296cd84bb26d901",
"assets/packages/flutter_localized_locales/data/cs_CZ.json": "0e530a7012340fe2b296cd84bb26d901",
"assets/packages/flutter_localized_locales/data/cy.json": "27580b96278f7197ad5cb38d0341207b",
"assets/packages/flutter_localized_locales/data/cy_GB.json": "27580b96278f7197ad5cb38d0341207b",
"assets/packages/flutter_localized_locales/data/da.json": "8f850a1c09d71493baea7a283d64558e",
"assets/packages/flutter_localized_locales/data/da_DK.json": "8f850a1c09d71493baea7a283d64558e",
"assets/packages/flutter_localized_locales/data/da_GL.json": "8f850a1c09d71493baea7a283d64558e",
"assets/packages/flutter_localized_locales/data/de.json": "b1f57db62c3295304a2f205255ed36bb",
"assets/packages/flutter_localized_locales/data/de_AT.json": "b1f57db62c3295304a2f205255ed36bb",
"assets/packages/flutter_localized_locales/data/de_BE.json": "b1f57db62c3295304a2f205255ed36bb",
"assets/packages/flutter_localized_locales/data/de_CH.json": "ca170e4563eb550dfbd44f1db0065a8d",
"assets/packages/flutter_localized_locales/data/de_DE.json": "b1f57db62c3295304a2f205255ed36bb",
"assets/packages/flutter_localized_locales/data/de_LI.json": "b1f57db62c3295304a2f205255ed36bb",
"assets/packages/flutter_localized_locales/data/de_LU.json": "b1f57db62c3295304a2f205255ed36bb",
"assets/packages/flutter_localized_locales/data/dz.json": "8fc4138f937c8befb22dc23f5ca43407",
"assets/packages/flutter_localized_locales/data/dz_BT.json": "8fc4138f937c8befb22dc23f5ca43407",
"assets/packages/flutter_localized_locales/data/ee.json": "759577ec0b59da61a03d187167b4dabc",
"assets/packages/flutter_localized_locales/data/ee_GH.json": "759577ec0b59da61a03d187167b4dabc",
"assets/packages/flutter_localized_locales/data/ee_TG.json": "759577ec0b59da61a03d187167b4dabc",
"assets/packages/flutter_localized_locales/data/el.json": "c7d79c7c974a365649b3c332b8900ef7",
"assets/packages/flutter_localized_locales/data/el_CY.json": "c7d79c7c974a365649b3c332b8900ef7",
"assets/packages/flutter_localized_locales/data/el_GR.json": "c7d79c7c974a365649b3c332b8900ef7",
"assets/packages/flutter_localized_locales/data/en.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_AG.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_AI.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_AS.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_AU.json": "27fa48bcc89880e0d512ecaba6555a87",
"assets/packages/flutter_localized_locales/data/en_BB.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_BE.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_BM.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_BS.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_BW.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_BZ.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_CA.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_CC.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_CK.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_CM.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_CX.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_DG.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_DM.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_ER.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_FJ.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_FK.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_FM.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_GB.json": "e19af59d44307533d0dc0b8ba8d84fca",
"assets/packages/flutter_localized_locales/data/en_GD.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_GG.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_GH.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_GI.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_GM.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_GU.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_GY.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_HK.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_IE.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_IM.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_IN.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_IO.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_JE.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_JM.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_KE.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_KI.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_KN.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_KY.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_LC.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_LR.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_LS.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_MG.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_MH.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_MO.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_MP.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_MS.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_MT.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_MU.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_MW.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_MY.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_NA.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_NF.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_NG.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_NR.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_NU.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_NZ.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_PG.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_PH.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_PK.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_PN.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_PR.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_PW.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_RW.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_SB.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_SC.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_SD.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_SG.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_SH.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_SL.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_SS.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_SX.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_SZ.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_TC.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_TK.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_TO.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_TT.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_TV.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_TZ.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_UG.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_UM.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_US.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_VC.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_VG.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_VI.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_VU.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_WS.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_ZA.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_ZM.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/en_ZW.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/eo.json": "f93a44216819e3b7c39ebe42b68ed284",
"assets/packages/flutter_localized_locales/data/es.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_AR.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_BO.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_CL.json": "84ab04311b26dd2bf56ebb9e81c39d6e",
"assets/packages/flutter_localized_locales/data/es_CO.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_CR.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_CU.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_DO.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_EA.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_EC.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_ES.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_GQ.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_GT.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_HN.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_IC.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_MX.json": "32ef00d44cd97bcb403a83bbb58f0eb7",
"assets/packages/flutter_localized_locales/data/es_NI.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_PA.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_PE.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_PH.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_PR.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_PY.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_SV.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_US.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_UY.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/es_VE.json": "dc35123c573f781934203b85cdae33cb",
"assets/packages/flutter_localized_locales/data/et.json": "b53cb42844282872c2e9b85bcb1f4ddc",
"assets/packages/flutter_localized_locales/data/et_EE.json": "b53cb42844282872c2e9b85bcb1f4ddc",
"assets/packages/flutter_localized_locales/data/eu.json": "558bfcf5ac42095d9ca444f41ecdc4d7",
"assets/packages/flutter_localized_locales/data/eu_ES.json": "558bfcf5ac42095d9ca444f41ecdc4d7",
"assets/packages/flutter_localized_locales/data/fa.json": "ea161036c0b1b8948d7a109c907b78f0",
"assets/packages/flutter_localized_locales/data/fa_AF.json": "86f109ff401ab71123a421f0174bec93",
"assets/packages/flutter_localized_locales/data/fa_IR.json": "ea161036c0b1b8948d7a109c907b78f0",
"assets/packages/flutter_localized_locales/data/ff.json": "e44663a4329ad578c923369c47d4f971",
"assets/packages/flutter_localized_locales/data/ff_CM.json": "e44663a4329ad578c923369c47d4f971",
"assets/packages/flutter_localized_locales/data/ff_GN.json": "e44663a4329ad578c923369c47d4f971",
"assets/packages/flutter_localized_locales/data/ff_MR.json": "e44663a4329ad578c923369c47d4f971",
"assets/packages/flutter_localized_locales/data/ff_SN.json": "e44663a4329ad578c923369c47d4f971",
"assets/packages/flutter_localized_locales/data/fi.json": "f722f31c6050b9bc24886f0d70c7ba5f",
"assets/packages/flutter_localized_locales/data/fi_FI.json": "f722f31c6050b9bc24886f0d70c7ba5f",
"assets/packages/flutter_localized_locales/data/fo.json": "eb1174195eb5d6d07396b82a0db50393",
"assets/packages/flutter_localized_locales/data/fo_FO.json": "eb1174195eb5d6d07396b82a0db50393",
"assets/packages/flutter_localized_locales/data/fr.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_BE.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_BF.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_BI.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_BJ.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_BL.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_CA.json": "4bf043a87fb30c3740dfeb99cc15656f",
"assets/packages/flutter_localized_locales/data/fr_CD.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_CF.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_CG.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_CH.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_CI.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_CM.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_DJ.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_DZ.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_FR.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_GA.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_GF.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_GN.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_GP.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_GQ.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_HT.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_KM.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_LU.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_MA.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_MC.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_MF.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_MG.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_ML.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_MQ.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_MR.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_MU.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_NC.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_NE.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_PF.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_PM.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_RE.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_RW.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_SC.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_SN.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_SY.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_TD.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_TG.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_TN.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_VU.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_WF.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fr_YT.json": "26d635787910816d372473bd9298db02",
"assets/packages/flutter_localized_locales/data/fy.json": "fa175dda321bac335d2dc6cd0a620be1",
"assets/packages/flutter_localized_locales/data/fy_NL.json": "fa175dda321bac335d2dc6cd0a620be1",
"assets/packages/flutter_localized_locales/data/ga.json": "469074c10bd432557b920d4e522d9749",
"assets/packages/flutter_localized_locales/data/ga_IE.json": "469074c10bd432557b920d4e522d9749",
"assets/packages/flutter_localized_locales/data/gd.json": "8e3f0505ef29751c4ef86bd5bfd8e844",
"assets/packages/flutter_localized_locales/data/gd_GB.json": "8e3f0505ef29751c4ef86bd5bfd8e844",
"assets/packages/flutter_localized_locales/data/gl.json": "7beef3c2787e8a6c0e8f395c520a59d7",
"assets/packages/flutter_localized_locales/data/gl_ES.json": "7beef3c2787e8a6c0e8f395c520a59d7",
"assets/packages/flutter_localized_locales/data/gu.json": "51070da2dbcde2a6fb879b859689f549",
"assets/packages/flutter_localized_locales/data/gu_IN.json": "51070da2dbcde2a6fb879b859689f549",
"assets/packages/flutter_localized_locales/data/gv.json": "ffe74cd8e052d6c7885d4b04585c1025",
"assets/packages/flutter_localized_locales/data/gv_IM.json": "ffe74cd8e052d6c7885d4b04585c1025",
"assets/packages/flutter_localized_locales/data/ha.json": "9eebdba073120807a14d142dd13d68f6",
"assets/packages/flutter_localized_locales/data/ha_GH.json": "9eebdba073120807a14d142dd13d68f6",
"assets/packages/flutter_localized_locales/data/ha_Latn.json": "9eebdba073120807a14d142dd13d68f6",
"assets/packages/flutter_localized_locales/data/ha_Latn_GH.json": "9eebdba073120807a14d142dd13d68f6",
"assets/packages/flutter_localized_locales/data/ha_Latn_NE.json": "9eebdba073120807a14d142dd13d68f6",
"assets/packages/flutter_localized_locales/data/ha_Latn_NG.json": "9eebdba073120807a14d142dd13d68f6",
"assets/packages/flutter_localized_locales/data/ha_NE.json": "9eebdba073120807a14d142dd13d68f6",
"assets/packages/flutter_localized_locales/data/ha_NG.json": "9eebdba073120807a14d142dd13d68f6",
"assets/packages/flutter_localized_locales/data/he.json": "32b5c8c74e555aa6b57d3b71a09211a3",
"assets/packages/flutter_localized_locales/data/he_IL.json": "32b5c8c74e555aa6b57d3b71a09211a3",
"assets/packages/flutter_localized_locales/data/hi.json": "c32d92fe3161f4cff403325d78cab31e",
"assets/packages/flutter_localized_locales/data/hi_IN.json": "c32d92fe3161f4cff403325d78cab31e",
"assets/packages/flutter_localized_locales/data/hr.json": "7fb5407e0c2b5d386a106d5b2f9e3ba7",
"assets/packages/flutter_localized_locales/data/hr_BA.json": "7fb5407e0c2b5d386a106d5b2f9e3ba7",
"assets/packages/flutter_localized_locales/data/hr_HR.json": "7fb5407e0c2b5d386a106d5b2f9e3ba7",
"assets/packages/flutter_localized_locales/data/hu.json": "1352cc96180f7cb92aa66ea0de66fb98",
"assets/packages/flutter_localized_locales/data/hu_HU.json": "1352cc96180f7cb92aa66ea0de66fb98",
"assets/packages/flutter_localized_locales/data/hy.json": "afda6cbecd7c8bcc262628171b9e57a6",
"assets/packages/flutter_localized_locales/data/hy_AM.json": "afda6cbecd7c8bcc262628171b9e57a6",
"assets/packages/flutter_localized_locales/data/id.json": "8ac870ed6bbe282ce06bfb8863aaa4d4",
"assets/packages/flutter_localized_locales/data/id_ID.json": "8ac870ed6bbe282ce06bfb8863aaa4d4",
"assets/packages/flutter_localized_locales/data/ig.json": "604e2f2736c6a484b39fd884fd8c3351",
"assets/packages/flutter_localized_locales/data/ig_NG.json": "604e2f2736c6a484b39fd884fd8c3351",
"assets/packages/flutter_localized_locales/data/ii.json": "88b5007a1ae0af95287d2a2bd38da28c",
"assets/packages/flutter_localized_locales/data/ii_CN.json": "88b5007a1ae0af95287d2a2bd38da28c",
"assets/packages/flutter_localized_locales/data/is.json": "1754da5052ddb6a0c50d47bbdc16f868",
"assets/packages/flutter_localized_locales/data/is_IS.json": "1754da5052ddb6a0c50d47bbdc16f868",
"assets/packages/flutter_localized_locales/data/it.json": "99e2dc0ac952c2163a6075ab3f5897ff",
"assets/packages/flutter_localized_locales/data/it_CH.json": "99e2dc0ac952c2163a6075ab3f5897ff",
"assets/packages/flutter_localized_locales/data/it_IT.json": "99e2dc0ac952c2163a6075ab3f5897ff",
"assets/packages/flutter_localized_locales/data/it_SM.json": "99e2dc0ac952c2163a6075ab3f5897ff",
"assets/packages/flutter_localized_locales/data/ja.json": "308371a4ce5bcbfb667dfcaa8975dfa9",
"assets/packages/flutter_localized_locales/data/ja_JP.json": "308371a4ce5bcbfb667dfcaa8975dfa9",
"assets/packages/flutter_localized_locales/data/ka.json": "115a96cae677145a8f4e2ad6030edc37",
"assets/packages/flutter_localized_locales/data/ka_GE.json": "115a96cae677145a8f4e2ad6030edc37",
"assets/packages/flutter_localized_locales/data/ki.json": "8ca28768445defe7a117cd5a11d74fba",
"assets/packages/flutter_localized_locales/data/ki_KE.json": "8ca28768445defe7a117cd5a11d74fba",
"assets/packages/flutter_localized_locales/data/kk.json": "836780ef5836e4acf454bb5e4d0fdf20",
"assets/packages/flutter_localized_locales/data/kk_Cyrl.json": "836780ef5836e4acf454bb5e4d0fdf20",
"assets/packages/flutter_localized_locales/data/kk_Cyrl_KZ.json": "836780ef5836e4acf454bb5e4d0fdf20",
"assets/packages/flutter_localized_locales/data/kk_KZ.json": "836780ef5836e4acf454bb5e4d0fdf20",
"assets/packages/flutter_localized_locales/data/kl.json": "70853af108684cdbe437941095d0fe80",
"assets/packages/flutter_localized_locales/data/kl_GL.json": "70853af108684cdbe437941095d0fe80",
"assets/packages/flutter_localized_locales/data/km.json": "943eaeff8cf3b6b9befcac453cd3ee2f",
"assets/packages/flutter_localized_locales/data/km_KH.json": "943eaeff8cf3b6b9befcac453cd3ee2f",
"assets/packages/flutter_localized_locales/data/kn.json": "519b2eb0609d9c91ef9c9991f2e8982b",
"assets/packages/flutter_localized_locales/data/kn_IN.json": "519b2eb0609d9c91ef9c9991f2e8982b",
"assets/packages/flutter_localized_locales/data/ko.json": "776090ce18472fffc8e4038e2eadcdfb",
"assets/packages/flutter_localized_locales/data/ko_KP.json": "776090ce18472fffc8e4038e2eadcdfb",
"assets/packages/flutter_localized_locales/data/ko_KR.json": "776090ce18472fffc8e4038e2eadcdfb",
"assets/packages/flutter_localized_locales/data/ks.json": "332dc5172ab3f99f592ab72517f280d3",
"assets/packages/flutter_localized_locales/data/ks_Arab.json": "332dc5172ab3f99f592ab72517f280d3",
"assets/packages/flutter_localized_locales/data/ks_Arab_IN.json": "332dc5172ab3f99f592ab72517f280d3",
"assets/packages/flutter_localized_locales/data/ks_IN.json": "332dc5172ab3f99f592ab72517f280d3",
"assets/packages/flutter_localized_locales/data/kw.json": "0ef6ee4b8e1ae1e800e1dab3b8ee85de",
"assets/packages/flutter_localized_locales/data/kw_GB.json": "0ef6ee4b8e1ae1e800e1dab3b8ee85de",
"assets/packages/flutter_localized_locales/data/ky.json": "27e97f6b12a5b46c03bd869470c1ad02",
"assets/packages/flutter_localized_locales/data/ky_Cyrl.json": "27e97f6b12a5b46c03bd869470c1ad02",
"assets/packages/flutter_localized_locales/data/ky_Cyrl_KG.json": "27e97f6b12a5b46c03bd869470c1ad02",
"assets/packages/flutter_localized_locales/data/ky_KG.json": "27e97f6b12a5b46c03bd869470c1ad02",
"assets/packages/flutter_localized_locales/data/lb.json": "651707f1a24ff24113c023aeae2b09af",
"assets/packages/flutter_localized_locales/data/lb_LU.json": "651707f1a24ff24113c023aeae2b09af",
"assets/packages/flutter_localized_locales/data/lg.json": "1198076a1b16b7d48f84e29e9788040f",
"assets/packages/flutter_localized_locales/data/lg_UG.json": "1198076a1b16b7d48f84e29e9788040f",
"assets/packages/flutter_localized_locales/data/ln.json": "0033fd816c3fd2e12d7403a88f48267a",
"assets/packages/flutter_localized_locales/data/ln_AO.json": "0033fd816c3fd2e12d7403a88f48267a",
"assets/packages/flutter_localized_locales/data/ln_CD.json": "0033fd816c3fd2e12d7403a88f48267a",
"assets/packages/flutter_localized_locales/data/ln_CF.json": "0033fd816c3fd2e12d7403a88f48267a",
"assets/packages/flutter_localized_locales/data/ln_CG.json": "0033fd816c3fd2e12d7403a88f48267a",
"assets/packages/flutter_localized_locales/data/lo.json": "66cbcbb10d379c7370c93e5f58fefa85",
"assets/packages/flutter_localized_locales/data/lo_LA.json": "66cbcbb10d379c7370c93e5f58fefa85",
"assets/packages/flutter_localized_locales/data/lt.json": "896a497c93a1eed305d28b181e10534d",
"assets/packages/flutter_localized_locales/data/lt_LT.json": "896a497c93a1eed305d28b181e10534d",
"assets/packages/flutter_localized_locales/data/lu.json": "ca69b4435f48a058c4ec3b85473748ff",
"assets/packages/flutter_localized_locales/data/lu_CD.json": "ca69b4435f48a058c4ec3b85473748ff",
"assets/packages/flutter_localized_locales/data/lv.json": "d26ab7cc596eb13ad2d86920baf09164",
"assets/packages/flutter_localized_locales/data/lv_LV.json": "d26ab7cc596eb13ad2d86920baf09164",
"assets/packages/flutter_localized_locales/data/mg.json": "0fdce89d1228f5bf8ef9f47476dbd724",
"assets/packages/flutter_localized_locales/data/mg_MG.json": "0fdce89d1228f5bf8ef9f47476dbd724",
"assets/packages/flutter_localized_locales/data/mk.json": "fecc8e3fc07b091473b9f6504e699280",
"assets/packages/flutter_localized_locales/data/mk_MK.json": "fecc8e3fc07b091473b9f6504e699280",
"assets/packages/flutter_localized_locales/data/ml.json": "877cd5ddf9c4018e6a933a2ba982985e",
"assets/packages/flutter_localized_locales/data/ml_IN.json": "877cd5ddf9c4018e6a933a2ba982985e",
"assets/packages/flutter_localized_locales/data/mn.json": "b6e86d99b76b4e73356abed32db1b71c",
"assets/packages/flutter_localized_locales/data/mn_Cyrl.json": "b6e86d99b76b4e73356abed32db1b71c",
"assets/packages/flutter_localized_locales/data/mn_Cyrl_MN.json": "b6e86d99b76b4e73356abed32db1b71c",
"assets/packages/flutter_localized_locales/data/mn_MN.json": "b6e86d99b76b4e73356abed32db1b71c",
"assets/packages/flutter_localized_locales/data/mr.json": "47cd8b1246278c5c4819225e6741f115",
"assets/packages/flutter_localized_locales/data/mr_IN.json": "47cd8b1246278c5c4819225e6741f115",
"assets/packages/flutter_localized_locales/data/ms.json": "27e154e05b4a81306cc217ff55a632f8",
"assets/packages/flutter_localized_locales/data/ms_BN.json": "27e154e05b4a81306cc217ff55a632f8",
"assets/packages/flutter_localized_locales/data/ms_Latn.json": "27e154e05b4a81306cc217ff55a632f8",
"assets/packages/flutter_localized_locales/data/ms_Latn_BN.json": "27e154e05b4a81306cc217ff55a632f8",
"assets/packages/flutter_localized_locales/data/ms_Latn_MY.json": "27e154e05b4a81306cc217ff55a632f8",
"assets/packages/flutter_localized_locales/data/ms_Latn_SG.json": "27e154e05b4a81306cc217ff55a632f8",
"assets/packages/flutter_localized_locales/data/ms_MY.json": "27e154e05b4a81306cc217ff55a632f8",
"assets/packages/flutter_localized_locales/data/ms_SG.json": "27e154e05b4a81306cc217ff55a632f8",
"assets/packages/flutter_localized_locales/data/mt.json": "8392a816c98ff640b3021dfdf28ac67c",
"assets/packages/flutter_localized_locales/data/mt_MT.json": "8392a816c98ff640b3021dfdf28ac67c",
"assets/packages/flutter_localized_locales/data/my.json": "78f705555bcd8f010108457e0af68b86",
"assets/packages/flutter_localized_locales/data/my_MM.json": "78f705555bcd8f010108457e0af68b86",
"assets/packages/flutter_localized_locales/data/nb.json": "8b1ee1d78b3734ed728326faf6afd3f1",
"assets/packages/flutter_localized_locales/data/nb_NO.json": "8b1ee1d78b3734ed728326faf6afd3f1",
"assets/packages/flutter_localized_locales/data/nb_SJ.json": "8b1ee1d78b3734ed728326faf6afd3f1",
"assets/packages/flutter_localized_locales/data/nd.json": "3a162249d400bbd55cfb6437f82d2f16",
"assets/packages/flutter_localized_locales/data/nd_ZW.json": "3a162249d400bbd55cfb6437f82d2f16",
"assets/packages/flutter_localized_locales/data/ne.json": "6c0588011ac72f7871ea5442c2bcbe62",
"assets/packages/flutter_localized_locales/data/ne_IN.json": "6c0588011ac72f7871ea5442c2bcbe62",
"assets/packages/flutter_localized_locales/data/ne_NP.json": "6c0588011ac72f7871ea5442c2bcbe62",
"assets/packages/flutter_localized_locales/data/nl.json": "2155bb57b15441e348bd7e9a06b92d9d",
"assets/packages/flutter_localized_locales/data/nl_AW.json": "2155bb57b15441e348bd7e9a06b92d9d",
"assets/packages/flutter_localized_locales/data/nl_BE.json": "136c7c4b6791ed01b2618eb30441392c",
"assets/packages/flutter_localized_locales/data/nl_BQ.json": "2155bb57b15441e348bd7e9a06b92d9d",
"assets/packages/flutter_localized_locales/data/nl_CW.json": "2155bb57b15441e348bd7e9a06b92d9d",
"assets/packages/flutter_localized_locales/data/nl_NL.json": "2155bb57b15441e348bd7e9a06b92d9d",
"assets/packages/flutter_localized_locales/data/nl_SR.json": "2155bb57b15441e348bd7e9a06b92d9d",
"assets/packages/flutter_localized_locales/data/nl_SX.json": "2155bb57b15441e348bd7e9a06b92d9d",
"assets/packages/flutter_localized_locales/data/nn.json": "5ff146246b77bd4a23dedd97e57afafc",
"assets/packages/flutter_localized_locales/data/nn_NO.json": "5ff146246b77bd4a23dedd97e57afafc",
"assets/packages/flutter_localized_locales/data/no.json": "452985cb3ae3f46758fd7b8844172687",
"assets/packages/flutter_localized_locales/data/no_NO.json": "452985cb3ae3f46758fd7b8844172687",
"assets/packages/flutter_localized_locales/data/om.json": "ecb0a9e7387ed41ee0e2c42bb89c7b19",
"assets/packages/flutter_localized_locales/data/om_ET.json": "ecb0a9e7387ed41ee0e2c42bb89c7b19",
"assets/packages/flutter_localized_locales/data/om_KE.json": "ecb0a9e7387ed41ee0e2c42bb89c7b19",
"assets/packages/flutter_localized_locales/data/or.json": "3a58097eb897eeb70fcb806d18fedbb4",
"assets/packages/flutter_localized_locales/data/or_IN.json": "3a58097eb897eeb70fcb806d18fedbb4",
"assets/packages/flutter_localized_locales/data/os.json": "a311f563294e5da4480ecdc681cffe35",
"assets/packages/flutter_localized_locales/data/os_GE.json": "a311f563294e5da4480ecdc681cffe35",
"assets/packages/flutter_localized_locales/data/os_RU.json": "a311f563294e5da4480ecdc681cffe35",
"assets/packages/flutter_localized_locales/data/pa.json": "6fcb5606c3b26afd42c61a3a5d6917ec",
"assets/packages/flutter_localized_locales/data/pa_Arab.json": "34f40ee5ca5c12c04d0ae6ef56ad98a8",
"assets/packages/flutter_localized_locales/data/pa_Arab_PK.json": "34f40ee5ca5c12c04d0ae6ef56ad98a8",
"assets/packages/flutter_localized_locales/data/pa_Guru.json": "6fcb5606c3b26afd42c61a3a5d6917ec",
"assets/packages/flutter_localized_locales/data/pa_Guru_IN.json": "6fcb5606c3b26afd42c61a3a5d6917ec",
"assets/packages/flutter_localized_locales/data/pa_IN.json": "6fcb5606c3b26afd42c61a3a5d6917ec",
"assets/packages/flutter_localized_locales/data/pa_PK.json": "6fcb5606c3b26afd42c61a3a5d6917ec",
"assets/packages/flutter_localized_locales/data/pl.json": "9e98121729085137d1c49eade7354576",
"assets/packages/flutter_localized_locales/data/pl_PL.json": "9e98121729085137d1c49eade7354576",
"assets/packages/flutter_localized_locales/data/ps.json": "6c1550ce6739aed17263ac1e81c699cb",
"assets/packages/flutter_localized_locales/data/ps_AF.json": "6c1550ce6739aed17263ac1e81c699cb",
"assets/packages/flutter_localized_locales/data/pt.json": "c21f730e59b89fd526dd593db7048ebd",
"assets/packages/flutter_localized_locales/data/pt_AO.json": "c21f730e59b89fd526dd593db7048ebd",
"assets/packages/flutter_localized_locales/data/pt_BR.json": "c21f730e59b89fd526dd593db7048ebd",
"assets/packages/flutter_localized_locales/data/pt_CV.json": "c21f730e59b89fd526dd593db7048ebd",
"assets/packages/flutter_localized_locales/data/pt_GW.json": "c21f730e59b89fd526dd593db7048ebd",
"assets/packages/flutter_localized_locales/data/pt_MO.json": "c21f730e59b89fd526dd593db7048ebd",
"assets/packages/flutter_localized_locales/data/pt_MZ.json": "c21f730e59b89fd526dd593db7048ebd",
"assets/packages/flutter_localized_locales/data/pt_PT.json": "e89939f10797756977f038ff80887a08",
"assets/packages/flutter_localized_locales/data/pt_ST.json": "c21f730e59b89fd526dd593db7048ebd",
"assets/packages/flutter_localized_locales/data/pt_TL.json": "c21f730e59b89fd526dd593db7048ebd",
"assets/packages/flutter_localized_locales/data/qu.json": "e16a99953a2ef9d08f70521d53c8fc28",
"assets/packages/flutter_localized_locales/data/qu_BO.json": "e16a99953a2ef9d08f70521d53c8fc28",
"assets/packages/flutter_localized_locales/data/qu_EC.json": "e16a99953a2ef9d08f70521d53c8fc28",
"assets/packages/flutter_localized_locales/data/qu_PE.json": "e16a99953a2ef9d08f70521d53c8fc28",
"assets/packages/flutter_localized_locales/data/rm.json": "c56bd56de571d5bc87abebed5c496de4",
"assets/packages/flutter_localized_locales/data/rm_CH.json": "c56bd56de571d5bc87abebed5c496de4",
"assets/packages/flutter_localized_locales/data/rn.json": "46df8add8b17e9c5f4380db765dadee3",
"assets/packages/flutter_localized_locales/data/rn_BI.json": "46df8add8b17e9c5f4380db765dadee3",
"assets/packages/flutter_localized_locales/data/ro.json": "cdf7787c446f89dacddbed2ee3758064",
"assets/packages/flutter_localized_locales/data/ro_MD.json": "cdf7787c446f89dacddbed2ee3758064",
"assets/packages/flutter_localized_locales/data/ro_RO.json": "cdf7787c446f89dacddbed2ee3758064",
"assets/packages/flutter_localized_locales/data/ru.json": "ecb670242bfea1c7e9f36eb6d95d1eb6",
"assets/packages/flutter_localized_locales/data/ru_BY.json": "ecb670242bfea1c7e9f36eb6d95d1eb6",
"assets/packages/flutter_localized_locales/data/ru_KG.json": "ecb670242bfea1c7e9f36eb6d95d1eb6",
"assets/packages/flutter_localized_locales/data/ru_KZ.json": "ecb670242bfea1c7e9f36eb6d95d1eb6",
"assets/packages/flutter_localized_locales/data/ru_MD.json": "ecb670242bfea1c7e9f36eb6d95d1eb6",
"assets/packages/flutter_localized_locales/data/ru_RU.json": "ecb670242bfea1c7e9f36eb6d95d1eb6",
"assets/packages/flutter_localized_locales/data/ru_UA.json": "ecb670242bfea1c7e9f36eb6d95d1eb6",
"assets/packages/flutter_localized_locales/data/rw.json": "dfdda1896b0c21aab00d453abe690767",
"assets/packages/flutter_localized_locales/data/rw_RW.json": "dfdda1896b0c21aab00d453abe690767",
"assets/packages/flutter_localized_locales/data/se.json": "cfc4513b41aa487da9072a12a7e0ad52",
"assets/packages/flutter_localized_locales/data/se_FI.json": "8407d3142ac9e058a1b3c99230f65f9a",
"assets/packages/flutter_localized_locales/data/se_NO.json": "cfc4513b41aa487da9072a12a7e0ad52",
"assets/packages/flutter_localized_locales/data/se_SE.json": "cfc4513b41aa487da9072a12a7e0ad52",
"assets/packages/flutter_localized_locales/data/sg.json": "f7578a392ec1d0da664cdd9020748109",
"assets/packages/flutter_localized_locales/data/sg_CF.json": "f7578a392ec1d0da664cdd9020748109",
"assets/packages/flutter_localized_locales/data/sh.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/sh_BA.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/si.json": "42a00269b24a0594a50a8c7dc7453f88",
"assets/packages/flutter_localized_locales/data/si_LK.json": "42a00269b24a0594a50a8c7dc7453f88",
"assets/packages/flutter_localized_locales/data/sk.json": "ff991dd5200ff6a9b262141533efb70d",
"assets/packages/flutter_localized_locales/data/sk_SK.json": "ff991dd5200ff6a9b262141533efb70d",
"assets/packages/flutter_localized_locales/data/sl.json": "3584d684951a2b0a22bef6c3db5c6016",
"assets/packages/flutter_localized_locales/data/sl_SI.json": "3584d684951a2b0a22bef6c3db5c6016",
"assets/packages/flutter_localized_locales/data/sn.json": "d70a9c4d951881577c975e6d74ba6f2f",
"assets/packages/flutter_localized_locales/data/sn_ZW.json": "d70a9c4d951881577c975e6d74ba6f2f",
"assets/packages/flutter_localized_locales/data/so.json": "ccb277a8ba503c8994491a6df6f5a51f",
"assets/packages/flutter_localized_locales/data/so_DJ.json": "ccb277a8ba503c8994491a6df6f5a51f",
"assets/packages/flutter_localized_locales/data/so_ET.json": "ccb277a8ba503c8994491a6df6f5a51f",
"assets/packages/flutter_localized_locales/data/so_KE.json": "ccb277a8ba503c8994491a6df6f5a51f",
"assets/packages/flutter_localized_locales/data/so_SO.json": "ccb277a8ba503c8994491a6df6f5a51f",
"assets/packages/flutter_localized_locales/data/sq.json": "03ea0818e97c80e8b5504fdc44fe8af1",
"assets/packages/flutter_localized_locales/data/sq_AL.json": "03ea0818e97c80e8b5504fdc44fe8af1",
"assets/packages/flutter_localized_locales/data/sq_MK.json": "03ea0818e97c80e8b5504fdc44fe8af1",
"assets/packages/flutter_localized_locales/data/sq_XK.json": "03ea0818e97c80e8b5504fdc44fe8af1",
"assets/packages/flutter_localized_locales/data/sr.json": "87869e860759adce97e2a07e5444f478",
"assets/packages/flutter_localized_locales/data/sr_BA.json": "87869e860759adce97e2a07e5444f478",
"assets/packages/flutter_localized_locales/data/sr_Cyrl.json": "87869e860759adce97e2a07e5444f478",
"assets/packages/flutter_localized_locales/data/sr_Cyrl_BA.json": "87869e860759adce97e2a07e5444f478",
"assets/packages/flutter_localized_locales/data/sr_Cyrl_ME.json": "87869e860759adce97e2a07e5444f478",
"assets/packages/flutter_localized_locales/data/sr_Cyrl_RS.json": "87869e860759adce97e2a07e5444f478",
"assets/packages/flutter_localized_locales/data/sr_Cyrl_XK.json": "87869e860759adce97e2a07e5444f478",
"assets/packages/flutter_localized_locales/data/sr_Latn.json": "6265b707ef237ee8c9902a29a426c49d",
"assets/packages/flutter_localized_locales/data/sr_Latn_BA.json": "6265b707ef237ee8c9902a29a426c49d",
"assets/packages/flutter_localized_locales/data/sr_Latn_ME.json": "6265b707ef237ee8c9902a29a426c49d",
"assets/packages/flutter_localized_locales/data/sr_Latn_RS.json": "6265b707ef237ee8c9902a29a426c49d",
"assets/packages/flutter_localized_locales/data/sr_Latn_XK.json": "6265b707ef237ee8c9902a29a426c49d",
"assets/packages/flutter_localized_locales/data/sr_ME.json": "87869e860759adce97e2a07e5444f478",
"assets/packages/flutter_localized_locales/data/sr_RS.json": "87869e860759adce97e2a07e5444f478",
"assets/packages/flutter_localized_locales/data/sr_XK.json": "87869e860759adce97e2a07e5444f478",
"assets/packages/flutter_localized_locales/data/sv.json": "a03cb2751576fd6708d64821131e5c7e",
"assets/packages/flutter_localized_locales/data/sv_AX.json": "a03cb2751576fd6708d64821131e5c7e",
"assets/packages/flutter_localized_locales/data/sv_FI.json": "575562480d96914a3a89ac08cbfd1641",
"assets/packages/flutter_localized_locales/data/sv_SE.json": "a03cb2751576fd6708d64821131e5c7e",
"assets/packages/flutter_localized_locales/data/sw.json": "4a2fc282b0ba63bfd56dd155c3cf097d",
"assets/packages/flutter_localized_locales/data/sw_KE.json": "4a2fc282b0ba63bfd56dd155c3cf097d",
"assets/packages/flutter_localized_locales/data/sw_TZ.json": "4a2fc282b0ba63bfd56dd155c3cf097d",
"assets/packages/flutter_localized_locales/data/sw_UG.json": "4a2fc282b0ba63bfd56dd155c3cf097d",
"assets/packages/flutter_localized_locales/data/ta.json": "5c2cb4a377b8031f8fa72f72c9469129",
"assets/packages/flutter_localized_locales/data/ta_IN.json": "5c2cb4a377b8031f8fa72f72c9469129",
"assets/packages/flutter_localized_locales/data/ta_LK.json": "5c2cb4a377b8031f8fa72f72c9469129",
"assets/packages/flutter_localized_locales/data/ta_MY.json": "5c2cb4a377b8031f8fa72f72c9469129",
"assets/packages/flutter_localized_locales/data/ta_SG.json": "5c2cb4a377b8031f8fa72f72c9469129",
"assets/packages/flutter_localized_locales/data/te.json": "c973029ab5210fb3cb9ade3a84ad8842",
"assets/packages/flutter_localized_locales/data/te_IN.json": "c973029ab5210fb3cb9ade3a84ad8842",
"assets/packages/flutter_localized_locales/data/th.json": "4625095ce54f8490999da1fe311f4209",
"assets/packages/flutter_localized_locales/data/th_TH.json": "4625095ce54f8490999da1fe311f4209",
"assets/packages/flutter_localized_locales/data/ti.json": "e8202caf5da9bb32d214f4d509f2940f",
"assets/packages/flutter_localized_locales/data/ti_ER.json": "e8202caf5da9bb32d214f4d509f2940f",
"assets/packages/flutter_localized_locales/data/ti_ET.json": "e8202caf5da9bb32d214f4d509f2940f",
"assets/packages/flutter_localized_locales/data/tl.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/tl_PH.json": "bf74d66b5e8e980eedf36a517daf8a7f",
"assets/packages/flutter_localized_locales/data/to.json": "7cd686b00b44cc51f4dede0b5db95f67",
"assets/packages/flutter_localized_locales/data/to_TO.json": "7cd686b00b44cc51f4dede0b5db95f67",
"assets/packages/flutter_localized_locales/data/tr.json": "69f5f4ed961e71f166dfa1618db7e942",
"assets/packages/flutter_localized_locales/data/tr_CY.json": "69f5f4ed961e71f166dfa1618db7e942",
"assets/packages/flutter_localized_locales/data/tr_TR.json": "69f5f4ed961e71f166dfa1618db7e942",
"assets/packages/flutter_localized_locales/data/ug.json": "39544db54054b43ac62ce25d7e964789",
"assets/packages/flutter_localized_locales/data/ug_Arab.json": "39544db54054b43ac62ce25d7e964789",
"assets/packages/flutter_localized_locales/data/ug_Arab_CN.json": "39544db54054b43ac62ce25d7e964789",
"assets/packages/flutter_localized_locales/data/ug_CN.json": "39544db54054b43ac62ce25d7e964789",
"assets/packages/flutter_localized_locales/data/uk.json": "1752736fd58a3ac34f643e9906f56dcd",
"assets/packages/flutter_localized_locales/data/uk_UA.json": "1752736fd58a3ac34f643e9906f56dcd",
"assets/packages/flutter_localized_locales/data/ur.json": "d8d925deac60e4c905a76f49b57387bf",
"assets/packages/flutter_localized_locales/data/ur_IN.json": "3a9d40c67f3f5d57dcb2a4358956a282",
"assets/packages/flutter_localized_locales/data/ur_PK.json": "d8d925deac60e4c905a76f49b57387bf",
"assets/packages/flutter_localized_locales/data/uz.json": "c2ce31f0afbc2b9b77f6088a0e707961",
"assets/packages/flutter_localized_locales/data/uz_AF.json": "c2ce31f0afbc2b9b77f6088a0e707961",
"assets/packages/flutter_localized_locales/data/uz_Arab.json": "55f433770fcaf3a9731ee12b6016d845",
"assets/packages/flutter_localized_locales/data/uz_Arab_AF.json": "55f433770fcaf3a9731ee12b6016d845",
"assets/packages/flutter_localized_locales/data/uz_Cyrl.json": "d28e6f4b3b9cc5e387e49c22e4053568",
"assets/packages/flutter_localized_locales/data/uz_Cyrl_UZ.json": "d28e6f4b3b9cc5e387e49c22e4053568",
"assets/packages/flutter_localized_locales/data/uz_Latn.json": "c2ce31f0afbc2b9b77f6088a0e707961",
"assets/packages/flutter_localized_locales/data/uz_Latn_UZ.json": "c2ce31f0afbc2b9b77f6088a0e707961",
"assets/packages/flutter_localized_locales/data/uz_UZ.json": "c2ce31f0afbc2b9b77f6088a0e707961",
"assets/packages/flutter_localized_locales/data/vi.json": "d696000908f8876200a47f4c70041d52",
"assets/packages/flutter_localized_locales/data/vi_VN.json": "d696000908f8876200a47f4c70041d52",
"assets/packages/flutter_localized_locales/data/yi.json": "b32e9f378af5af859de53a30d9d18c6c",
"assets/packages/flutter_localized_locales/data/yo.json": "a036030157e9d5104f9f8c685d183fae",
"assets/packages/flutter_localized_locales/data/yo_BJ.json": "7f77277d06c1eb49a0c69f982d4d7eb0",
"assets/packages/flutter_localized_locales/data/yo_NG.json": "a036030157e9d5104f9f8c685d183fae",
"assets/packages/flutter_localized_locales/data/zh.json": "62b608c1b6419632f312608335a7e9c3",
"assets/packages/flutter_localized_locales/data/zh_CN.json": "62b608c1b6419632f312608335a7e9c3",
"assets/packages/flutter_localized_locales/data/zh_Hans.json": "62b608c1b6419632f312608335a7e9c3",
"assets/packages/flutter_localized_locales/data/zh_Hans_CN.json": "62b608c1b6419632f312608335a7e9c3",
"assets/packages/flutter_localized_locales/data/zh_Hans_HK.json": "2ac1a2d96e9fa1111c6dc227461534bd",
"assets/packages/flutter_localized_locales/data/zh_Hans_MO.json": "0c520483792d7ea613be99d4a920cf79",
"assets/packages/flutter_localized_locales/data/zh_Hans_SG.json": "0c520483792d7ea613be99d4a920cf79",
"assets/packages/flutter_localized_locales/data/zh_Hant.json": "a336a155c02bf59982dd5ffc427a84d9",
"assets/packages/flutter_localized_locales/data/zh_Hant_HK.json": "a99034d2240311bfab6616096c000627",
"assets/packages/flutter_localized_locales/data/zh_Hant_MO.json": "a336a155c02bf59982dd5ffc427a84d9",
"assets/packages/flutter_localized_locales/data/zh_Hant_TW.json": "a336a155c02bf59982dd5ffc427a84d9",
"assets/packages/flutter_localized_locales/data/zh_HK.json": "83feaf4b539212076f79f6028ed91451",
"assets/packages/flutter_localized_locales/data/zh_MO.json": "83feaf4b539212076f79f6028ed91451",
"assets/packages/flutter_localized_locales/data/zh_SG.json": "62b608c1b6419632f312608335a7e9c3",
"assets/packages/flutter_localized_locales/data/zh_TW.json": "83feaf4b539212076f79f6028ed91451",
"assets/packages/flutter_localized_locales/data/zu.json": "bdb48dd1f3a2a1bc155b877294cc0655",
"assets/packages/flutter_localized_locales/data/zu_ZA.json": "bdb48dd1f3a2a1bc155b877294cc0655",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b392c64816c3c79d6e4b75fcf7396761",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "f3307f62ddff94d2cd8b103daf8d1b0f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "04f83c01dded195a11d21c2edf643455",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "e0908cf95211ce51dd34a4aba951f201",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "84d0dc93834bc38c02337a57312d4b6c",
"icons/Icon-144.png": "1a8de7ef693b8cde478e196d704714ff",
"icons/Icon-192.png": "b666811209223fc7b0eba539bd438825",
"icons/Icon-512.png": "b5e75d90e9cc7c1c3d19b778f13188df",
"icons/Icon-96.png": "8d07e38d5e799b5bc0808f7c4acf0e18",
"icons/Icon-maskable-192.png": "518bd88ab36204977f43557db7876c50",
"icons/Icon-maskable-512.png": "3a1debe33d268f8a130bae0676e6c48f",
"index.html": "b8c034ebba3022da0c1633e2db628152",
"/": "b8c034ebba3022da0c1633e2db628152",
"main.dart.js": "941d9fac1e841a179f8587b526618135",
"manifest.json": "72d5ce409048a4795d8698a0562bc6a1",
"version.json": "2abb95781693ca01cfe3a0b02a91afdc"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
