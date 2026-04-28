import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/rental_request.dart';
import '../../viewmodels/auth_provider.dart';
import '../../viewmodels/rental_provider.dart';
import '../add_rental/add_rental_item_page.dart';

class MyRentalsPage extends StatelessWidget {
  const MyRentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rentalProvider = context.watch<RentalProvider>();
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not found')));
    }

    final incoming = rentalProvider.getIncomingRequests(user.id);
    final outgoing = rentalProvider.getOutgoingRequests(user.id);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Rentals'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddRentalItemPage()),
                );
              },
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Add Item',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Incoming'),
              Tab(text: 'Requested'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _RequestsList(
              requests: incoming,
              emptyText: 'No incoming requests',
              onApprove: (id) => rentalProvider.updateRequestStatus(
                id,
                RentalRequestStatus.approved,
              ),
              onDecline: (id) => rentalProvider.updateRequestStatus(
                id,
                RentalRequestStatus.declined,
              ),
            ),
            _RequestsList(
              requests: outgoing,
              emptyText: 'No rental requests',
              onApprove: null,
              onDecline: null,
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestsList extends StatelessWidget {
  final List<RentalRequest> requests;
  final String emptyText;
  final void Function(String id)? onApprove;
  final void Function(String id)? onDecline;

  const _RequestsList({
    required this.requests,
    required this.emptyText,
    required this.onApprove,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Center(child: Text(emptyText));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        final request = requests[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.productName, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('Renter: ${request.renterName}'),
                Text('Days: ${request.days}'),
                Text('Total + deposit: ${(request.rentTotal + request.deposit).toStringAsFixed(0)}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(label: Text(request.status.name.toUpperCase())),
                    const Spacer(),
                    if (onApprove != null && request.status == RentalRequestStatus.pending)
                      TextButton(
                        onPressed: () => onDecline?.call(request.id),
                        child: const Text('Decline'),
                      ),
                    if (onApprove != null && request.status == RentalRequestStatus.pending)
                      ElevatedButton(
                        onPressed: () => onApprove?.call(request.id),
                        child: const Text('Approve'),
                      ),
                    if (onApprove == null && request.status == RentalRequestStatus.approved)
                      TextButton(
                        onPressed: () => _showRatingDialog(context, request),
                        child: const Text('Rate'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRatingDialog(BuildContext context, RentalRequest request) {
    double current = 5;
    final commentController = TextEditingController();
    final auth = context.read<AuthProvider>();
    final rental = context.read<RentalProvider>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (_, setState) {
            return AlertDialog(
              title: const Text('Rate owner'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    min: 1,
                    max: 5,
                    divisions: 4,
                    value: current,
                    label: current.toStringAsFixed(0),
                    onChanged: (value) => setState(() => current = value),
                  ),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(hintText: 'Comment (optional)'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final fromUserId = auth.currentUser?.id;
                    if (fromUserId == null) return;
                    rental.addReview(
                      fromUserId: fromUserId,
                      toUserId: request.ownerId,
                      requestId: request.id,
                      rating: current,
                      comment: commentController.text.trim(),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

