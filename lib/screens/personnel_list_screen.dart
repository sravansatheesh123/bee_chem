import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/personnel_provider.dart';
import '../widgets/personnel_card.dart';
import 'personnel_form_screen.dart';

class PersonnelListScreen extends StatefulWidget {
  const PersonnelListScreen({super.key});

  @override
  State<PersonnelListScreen> createState() => _PersonnelListScreenState();
}

class _PersonnelListScreenState extends State<PersonnelListScreen> {
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PersonnelProvider>().fetchPersonnel();
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  void _searchNow() {
    context.read<PersonnelProvider>().filterByName(searchCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PersonnelProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffFFC928),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PersonnelFormScreen(),
            ),
          );
        },
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Frame 18341.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.grid_view),
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  "Personnel Details List",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _searchNow,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xffFFC928),
                    child: const Text("GO", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Builder(
              builder: (_) {

                if (provider.isLoading) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(
                      child: Text(provider.error!,
                          style: TextStyle(color: Colors.red)));
                }

                if (provider.all.isEmpty) {
                  return const Center(child: Text("No records found"));
                }

                if (provider.filtered.isEmpty) {
                  return const Center(child: Text("No matches found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: provider.filtered.length,
                  itemBuilder: (_, i) =>
                      PersonnelCard(p: provider.filtered[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
