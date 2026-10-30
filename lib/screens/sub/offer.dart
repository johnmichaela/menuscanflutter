import 'package:flutter/material.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  bool _isLoading = false;
  // Mock empty list to represent no offers
  final List<dynamic> _offers = []; 

  Future<void> _refreshOffers() async {
    setState(() => _isLoading = true);
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 25),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Offers & Deals',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Offer Icon in AppBar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_offer_rounded, 
                color: Colors.amber, 
                size: 22,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading 
          ?  Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
          : _offers.isEmpty 
              ? _buildEmptyState(Theme.of(context).primaryColor)
              : const SizedBox(), // Replace with your ListView of offers when data exists
    );
  }

  Widget _buildEmptyState(Color primaryBlue) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large Stylized Offer Icon
            Container(
              width: 220,
              height: 220,
              // decoration: BoxDecoration(
              //   color: Theme.of(context).cardColor,
              //   shape: BoxShape.circle,
              //   boxShadow: [
              //     BoxShadow(
              //       color: primaryBlue.withOpacity(0.1),
              //       blurRadius: 20,
              //       spreadRadius: 5,
              //       offset: const Offset(0, 10),
              //     ),
              //   ],
              // ),
              child: Image.asset('assets/img/empty.png')
              // Center(
              //   child: Stack(
              //     alignment: Alignment.center,
              //     children: [
              //       Icon(
              //         Icons.local_offer_rounded,
              //         size: 60,
              //         color: Colors.amber.withOpacity(0.2),
              //       ),
              //       Icon(
              //         Icons.local_offer_rounded,
              //         size: 45,
              //         color: Colors.amber,
              //       ),
              //       // Small "X" or slash to indicate unavailability
              //       Positioned(
              //         bottom: 28,
              //         right: 28,
              //         child: Container(
              //           padding: const EdgeInsets.all(4),
              //           decoration: const BoxDecoration(
              //             color: Colors.white,
              //             shape: BoxShape.circle,
              //           ),
              //           child: const Icon(
              //             Icons.close_rounded,
              //             size: 16,
              //             color: Colors.redAccent,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ),
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'No Offers Available',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                // color: Color(0xFF183153),
              ),
            ),
            const SizedBox(height: 12),
            
            // Subtitle
            Text(
              'We couldn\'t find any active offers or deals in your area right now. Check back later for exclusive discounts!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            
            // Refresh Button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _refreshOffers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Refresh Offers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
}