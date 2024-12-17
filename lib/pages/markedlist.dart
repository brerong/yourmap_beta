import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarkedListScreen extends StatefulWidget {
  const MarkedListScreen({Key? key}) : super(key: key);

  @override
  _MarkedListScreenState createState() => _MarkedListScreenState();
}

class _MarkedListScreenState extends State<MarkedListScreen> {
  final List<Map<String, dynamic>> _markers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMarkers();
  }

  Future<void> _fetchMarkers() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User belum login");
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('markers')
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final String locationName = await _getLocationName(
              data['latitude'], data['longitude']);

          setState(() {
            _markers.add({
              'title': data['title'],
              'description': data['description'],
              'location': locationName,
            });
          });
        }
      }
    } catch (e) {
      print("Error fetching markers: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getLocationName(double lat, double lon) async {
    try {
      final url =
          'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      return data['display_name'] ?? "Unknown Location";
    } catch (e) {
      print("Error fetching location name: $e");
      return "Unknown Location";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EFF4),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "List of Wonders",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _markers.isEmpty
          ? const Center(
        child: Text(
          "Belum menambahkan marker",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: _markers.length,
        itemBuilder: (context, index) {
          final marker = _markers[index];
          return _buildMarkerCard(marker);
        },
      ),
    );
  }

  Widget _buildMarkerCard(Map<String, dynamic> marker) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            marker['title'] ?? "No Title",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            marker['description'] ?? "No Description",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            marker['location'] ?? "Location not found",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}