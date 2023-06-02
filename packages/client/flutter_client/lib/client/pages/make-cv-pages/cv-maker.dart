import 'package:flutter/material.dart';

class InputCollection extends StatefulWidget {
  @override
  _InputCollectionState createState() => _InputCollectionState();
}

class _InputCollectionState extends State<InputCollection> {
  List<ExpandableCard> employmentHistory = [];
  List<ExpandableCard> education = [];
  List<ExpandableCard> websites = [];

  void addEmploymentCard() {
    setState(() {
      employmentHistory.add(ExpandableCard());
    });
  }

  void removeEmploymentCard(int index) {
    setState(() {
      employmentHistory.removeAt(index);
    });
  }

  void addEducationCard() {
    setState(() {
      education.add(ExpandableCard());
    });
  }

  void removeEducationCard(int index) {
    setState(() {
      education.removeAt(index);
    });
  }

  void addWebsiteCard() {
    setState(() {
      websites.add(ExpandableCard());
    });
  }

  void removeWebsiteCard(int index) {
    setState(() {
      websites.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Collection'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Section(
            title: 'Personal Details',
            description: 'Auto generate for me',
            children: [
              TextInputField(label: 'Wanted Job Title', required: true),
              FileInputField(label: 'Upload Profile Picture', required: true),
              TextInputField(label: 'First Name', required: true),
              TextInputField(label: 'Last Name', required: true),
              TextInputField(label: 'Email', required: true),
              TextInputField(label: 'Phone', required: true),
              TextInputField(label: 'Country', required: true),
              TextInputField(label: 'City', required: true),
              TextInputField(label: 'Address', required: true),
              TextInputField(label: 'Postal Code', required: true),
              TextInputField(label: 'Driving License'),
              TextInputField(label: 'Nationality', required: true),
              TextInputField(label: 'Place Of Birth'),
              TextInputField(label: 'Date Of Birth', required: true),
            ],
          ),
          Section(
            title: 'Professional Summary',
            description:
                'Write 2-4 short & energetic sentences to interest the reader! Mention your role, experience & most importantly - your biggest achievements, best qualities and skills.',
            children: [
              TextInputField(label: 'Professional Summary'),
            ],
          ),
          Section(
            title: 'Employment History',
            description:
                'Show your relevant experience (last 10 years). Use bullet points to note your achievements, if possible - use numbers/facts (Achieved X, measured by Y, by doing Z).',
            children: [
              ...employmentHistory,
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: addEmploymentCard,
                icon: Icon(Icons.add),
                label: Text('Add one more employment'),
              ),
            ],
          ),
          Section(
            title: 'Education',
            description:
                'A varied education on your resume sums up the value that your learnings and background will bring to the job.',
            children: [
              ...education,
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: addEducationCard,
                icon: Icon(Icons.add),
                label: Text('Add one more education'),
              ),
            ],
          ),
          Section(
            title: 'Websites & Social Links',
            description:
                'You can add links to websites you want hiring managers to see! Perhaps It will be a link to your portfolio, LinkedIn profile, or personal website.',
            children: [
              ...websites,
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: addWebsiteCard,
                icon: Icon(Icons.add),
                label: Text('Add one more link'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> children;

  Section({
    required this.title,
    required this.description,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Text(description),
        SizedBox(height: 16.0),
        ...children,
      ],
    );
  }
}

class TextInputField extends StatelessWidget {
  final String label;
  final bool required;

  TextInputField({
    required this.label,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: required ? 'Required' : '',
      ),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            }
          : null,
    );
  }
}

class FileInputField extends StatelessWidget {
  final String label;
  final bool required;

  FileInputField({
    required this.label,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: required ? 'Required' : '',
      ),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            }
          : null,
      // Replace with file input logic
      // For example: FilePicker, ImagePicker, etc.
    );
  }
}

class ExpandableCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInputField(label: 'Job Title', required: true),
            TextInputField(label: 'Employer'),
            Row(
              children: [
                Expanded(
                  child: TextInputField(label: 'Start Date', required: true),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextInputField(label: 'End Date', required: true),
                ),
              ],
            ),
            TextInputField(label: 'City', required: true),
            TextInputField(label: 'Description'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Handle card deletion
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
