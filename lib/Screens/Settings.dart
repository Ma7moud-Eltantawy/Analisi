import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rilevamento/Providers/Settings.dart';
import 'package:rilevamento/styles/Local_Styles.dart';

import '../models/faq_model.dart';
import '../styles/icons.dart';
import '../widgets/Conatctme_bouttomsheet.dart';
import '../widgets/material_button.dart';
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  static const scid="setting_screen";

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(

            'Settings',
            style: TextStyle(
              color: local_blue
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: FutureBuilder(
          future:   Provider.of<Settings_prov>(context,listen: false).get_faqs(),

          builder:(context,AsyncSnapshot <List<Faq_model>>snapshot)=>!snapshot.hasData?Center(child: CircularProgressIndicator(),): SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Legal',
                      style: TextStyle(
                        color: local_blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    dense: true,
                    horizontalTitleGap: -4,
                    //minLeadingWidth: 0,
                    minVerticalPadding: 15.0,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    tileColor: Colors.grey[50],
                    leading: Icon(
                      IconBroken.Shield_Done,
                      color: local_blue,
                      size: 26,
                    ),
                    title: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Icon(
                      IconBroken.Arrow___Right_2,
                      color: local_blue,
                      size: 26,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListTile(
                    onTap: () {
                      Contactme_bottom_sheet(context, height, width);

                    },
                    dense: true,
                    horizontalTitleGap: -4,
                    //minLeadingWidth: 0,
                    minVerticalPadding: 15.0,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    tileColor: Colors.grey[50],
                    leading: Icon(
                      IconBroken.Activity,
                      color: local_blue,
                      size: 26,
                    ),
                    title: Text(
                      'Contact Me',
                      style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Icon(
                      IconBroken.Arrow___Right_2,
                      color: local_blue,
                      size: 26,
                    ),
                  ),
                  // SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'FAQ',
                      style: TextStyle(
                        color: local_blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Consumer<Settings_prov>(
                          builder:(context,prov,ch)=> ExpansionTile(
                            backgroundColor: Colors.grey[50],
                            collapsedBackgroundColor: Colors.grey[50],
                            iconColor: local_blue,
                            childrenPadding: EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 15.0),
                            collapsedIconColor: local_blue,
                            tilePadding: EdgeInsets.symmetric(horizontal: 10.0),
                            controlAffinity: ListTileControlAffinity.trailing,
                            trailing: prov.Faqs[snapshot.data![index].id]==false?Icon(IconBroken.Arrow___Down_2):Icon(IconBroken.Arrow___Up_2),
                            title: Row(
                              children: [
                                Icon(IconBroken.Info_Circle, color: local_blue,
                                  size: 26,),
                                SizedBox(width: 10.0,),
                                Text(
                                  snapshot.data![index].question.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 14,color: local_blue),
                                ),
                              ],
                            ),
                            children: [
                              Text(
                                  snapshot.data![index].answer!
                              ),
                            ],
                            onExpansionChanged: (value) {
                              Provider.of<Settings_prov>(context,listen: false).faqstate(snapshot.data![index].id!, value);


                            },
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10.0,);
                    },
                  ),
                ],
              ),
            ),
          ),
        ) ,

      );
  }
}



