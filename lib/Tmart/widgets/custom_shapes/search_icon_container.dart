import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/search_product.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/TMart/colors.dart';
import 'package:flutter/cupertino.dart';

class SearchIconContainer extends StatelessWidget {

  final bool showBorder;
  const SearchIconContainer({
    super.key,
    this.showBorder=false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchProduct()));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), //taki niche ke container se radius match kar paye
          color:Colors.white,
          border: showBorder ? Border.all(color: Colors.black12) : null,
        ),
        clipBehavior: Clip.antiAlias,
        height: 52,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal:17.0) ,
        padding:EdgeInsets.symmetric(vertical: 8.0, horizontal:12.0),
        child: Center(
          child: Row(
            children: [
              Icon(Icons.search,size:30,color: TColors.primary,),
              SizedBox(width: 5,),
              Text(
                "Search to Store",
                style: TextStyle(color:Colors.black54,fontWeight: FontWeight.w500,fontSize:16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
