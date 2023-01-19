class _FormExampleState extends State<FormExample> {
	final _formKey = GlobalKey<FormState>();
	final _txtCtrl = TextEditingController();
	// ...

	@override
	Widget build(BuildContext context) {
		return Form(
			key: _formKey,
			child: Column(
				children: [
					// ..
					TextFormField(
						controller: _txtCtrl,
						validator: (value) {
							if (value?.isEmpty ?? true) return "Please Enter a Value";
							return null;
						},
					),
					// ..
					TextButton(
						child: const Text("Submit"),
						onPressed: () {
							if (!_formKey.currentState!.validate()) return;

							doSomethingWithValues(_txtCtrl.value, ...);
						},
					),
				],
			),
		);
	}
}

