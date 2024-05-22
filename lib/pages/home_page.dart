import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes/constants/colors.dart';
import 'package:notes/models/note.dart';
import 'package:notes/pages/edit.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

List<Note> filteredNotes=[];
bool sorted=false;

@override
void initState(){
  super.initState();
  filteredNotes=sampleNotes;
}

sortNotesByModifiedTime(List<Note>notes){
  if(sorted){
    notes.sort((a,b)=> a.modifiedTime.compareTo(b.modifiedTime));

  }else{
    notes.sort((b,a)=>a.modifiedTime.compareTo(b.modifiedTime));
  }
  sorted=!sorted;
  return notes;
}

getRandomColor(){
  Random random =Random();
  return backgroundColor[random.nextInt(backgroundColor.length)];
}
void onSearchTextchanged(String searchText){
  setState(() {
    filteredNotes=
  sampleNotes.where((note) => note.content.toLowerCase().contains(searchText.toLowerCase())).toList();
  });
}

void deleteNote(int index){
  setState(() {
    // Note note=filteredNotes[index];
    // sampleNotes.remove(note);
    filteredNotes.removeAt(index);
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16,40,16,0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notes',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                IconButton(onPressed: (){
                  setState(() {
                    filteredNotes=sortNotesByModifiedTime(filteredNotes);
                  });
                }, 
                padding: EdgeInsets.all(0),
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.grey.shade800.withOpacity(.8),
                  borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.sort,color: Colors.white,)

                  )
                  )
              ],
            ),
            SizedBox(height: 20,),
            TextField(
              onChanged: onSearchTextchanged,
              style: TextStyle(fontSize: 16,color: Colors.white),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                hintText: "Search notes...",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search,color: Colors.grey,),
                fillColor: Colors.grey.shade800,
                filled: true,
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent)
                ),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent)
                )
              ),
            ),
            Expanded(child: ListView.builder(
              padding: EdgeInsets.only(top: 30),
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 15),
                  color:getRandomColor(),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                        onTap: ()async{
                          final result=await Navigator.push(context,
          MaterialPageRoute(builder:(BuildContext context) => EditScreen(note: filteredNotes[index],),)); 
                        if(result!=null){
            setState(() {
              int originalIndex =sampleNotes.indexOf(filteredNotes[index]);
              sampleNotes[originalIndex]=Note(id: sampleNotes[originalIndex].id, title: result[0], content: result[1], modifiedTime: DateTime.now()
            );
             filteredNotes[index] = Note(id: sampleNotes[originalIndex].id, title: result[0], content: result[1], modifiedTime: DateTime.now()
            );;
            });
          }
                        
                  },

                      title: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text:TextSpan(
                        text: '${filteredNotes[index].title} \n',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          height: 1.5
                        ),
                        children: [
                                    
                          TextSpan(
                            text: filteredNotes[index].content,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.5
                            ),
                          )
                        ]
                      )),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top:8),
                        child: Text(
                          'Edited: ${DateFormat('EEE MMM d, yyyy h:mm a').format(filteredNotes[index].modifiedTime)}',
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade800
                          ),
                        ),
                      ),
                      trailing: IconButton(onPressed: () async{
                       final result = await confirmDialog(context);
                         if(result){
                            deleteNote(index);
                         }
                        
                      }, icon: Icon(Icons.delete,size: 26,)),
                    ),
                  ),
                );
              },
            ))
          ],
          
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:20 ),
        child: FloatingActionButton(onPressed: ()async{
          final result=await Navigator.push(context,
          MaterialPageRoute(builder:(BuildContext context) => EditScreen(),

           ),
          );
          if(result!=null){
            setState(() {
              sampleNotes.add(
              Note(id: sampleNotes.length, title: result[0], content: result[1], modifiedTime: DateTime.now()),
            );
             filteredNotes = sampleNotes;
            });
          }
        },
        backgroundColor:Colors.grey.shade800 ,
        elevation: 30,
  
        child: 
        Icon(Icons.add,size: 38,color: Colors.white,),),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(context :context,
                       builder: (BuildContext context){
                        return AlertDialog(
                          backgroundColor: Colors.grey.shade900,
                          icon: Icon(Icons.info,color: Colors.grey,),
                          title: Text(
                            'Are you sure you want to Delete ?',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                            ElevatedButton(onPressed: (){
                              Navigator.pop(context,true);
                            }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green
                            ),
                            child:SizedBox(
                              width: 60,
                              child: Text(
                              'Yes',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                                                          ),
                            ),
                            ),
                            ElevatedButton(onPressed: (){
                              Navigator.pop(context,false);
                            }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent
                            ),
                            child:SizedBox(
                              width: 60,
                              child: Text(
                              'No',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                                                          ),
                            ),
                            )
                          ],),
                        );
                        
                       });
  }
}