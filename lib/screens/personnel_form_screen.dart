import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/personnel_provider.dart';
import '../widgets/common_text_field.dart';
import '../models/role.dart';

class PersonnelFormScreen extends StatefulWidget {
  const PersonnelFormScreen({super.key});

  @override
  State<PersonnelFormScreen> createState() => _PersonnelFormScreenState();
}

class _PersonnelFormScreenState extends State<PersonnelFormScreen> {
  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final suburbCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final postcodeCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  bool isActive = true;
  ApiaryRole? selectedRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonnelProvider>().loadRoles();
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    addressCtrl.dispose();
    suburbCtrl.dispose();
    stateCtrl.dispose();
    postcodeCtrl.dispose();
    contactCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedRole == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Select a role')));
      return;
    }

    final provider = context.read<PersonnelProvider>();

    final message = await provider.addPersonnel(
      firstName: nameCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      suburb: suburbCtrl.text.trim(),
      state: stateCtrl.text.trim(),
      postcode: postcodeCtrl.text.trim(),
      contactNumber: contactCtrl.text.trim(),
      roleId: selectedRole!.id,
      isActive: isActive,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message ?? "Saved")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PersonnelProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(
              width: double.infinity,
              height: 170,
              child: Image.asset(
                "assets/images/Frame 18341.png",
                fit: BoxFit.cover,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      CommonTextField(
                        label: 'Full name',
                        hint: 'Please type',
                        controller: nameCtrl,
                        validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),

                      CommonTextField(
                        label: 'Address',
                        hint: 'Please type',
                        controller: addressCtrl,
                      ),
                      const SizedBox(height: 12),

                      CommonTextField(
                        label: 'Suburb',
                        hint: 'Please type',
                        controller: suburbCtrl,
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              label: 'State',
                              hint: 'Please type',
                              controller: stateCtrl,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CommonTextField(
                              label: 'Post code',
                              hint: 'Please type',
                              controller: postcodeCtrl,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      CommonTextField(
                        label: 'Contact number',
                        controller: contactCtrl,
                        hint: 'Please type',
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Role",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),

                      DropdownButtonFormField<ApiaryRole>(
                        value: selectedRole,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: provider.roles
                            .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.role)))
                            .toList(),
                        onChanged: (v) => setState(() => selectedRole = v),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Additional Notes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: notesCtrl,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Type here...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Status",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Switch(
                            value: isActive,
                            activeColor: Colors.green,
                            onChanged: (v) => setState(() => isActive = v),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text("CANCEL"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffFFC928),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: _save,
                              child: const Text(
                                "SAVE",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
