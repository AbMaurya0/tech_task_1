import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const ShimmerLoading({
    Key? key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  _ShimmerLoadingState createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.1, 0.3, 0.4],
              begin: Alignment(_animation.value, -0.5),
              end: Alignment(_animation.value + 1, 1.0),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// User List Shimmer - Matches exact dimensions of user list items
class UserListShimmer extends StatelessWidget {
  const UserListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width to calculate realistic width values
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemBuilder: (context, index) {
        return ShimmerLoading(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Avatar - Matches the 50px circle avatar radius from your ListTile
                  Container(
                    width: 50,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name - A realistic width for a full name (first + last name)
                        Container(
                          height: 16,
                          width: screenWidth *
                              0.4, // Approximately 40% of screen width
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Email - Usually longer than name
                        Container(
                          height: 14,
                          width: screenWidth *
                              0.6, // Approximately 60% of screen width
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add trailing icon placeholder
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// User Details Shimmer - Matches exact dimensions of user details
class UserDetailsShimmer extends StatelessWidget {
  const UserDetailsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width to calculate realistic width values
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Avatar - Matches the 70px radius from your CircleAvatar
            ShimmerLoading(
              child: Container(
                width: 140, // 2 * 70px radius
                height: 140, // 2 * 70px radius
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ShimmerLoading(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: screenWidth - 32, // Full width minus padding
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Name - Full name with large font size
                      Container(
                        height: 26, // Matches your text size of 26
                        width: screenWidth * 0.6, // 60% of screen width
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Divider
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 8),
                      // Email Row
                      _buildShimmerRow(
                        iconSize: 24,
                        labelWidth: screenWidth * 0.15, // Label width
                        valueWidth: screenWidth * 0.5, // Email width
                      ),
                      const SizedBox(height: 16),
                      // User ID Row
                      _buildShimmerRow(
                        iconSize: 24,
                        labelWidth: screenWidth * 0.15, // Label width
                        valueWidth: screenWidth * 0.2, // ID is shorter
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Refresh button
            ShimmerLoading(
              child: Container(
                height: 48,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerRow({
    required double iconSize,
    required double labelWidth,
    required double valueWidth,
  }) {
    return Row(
      children: [
        // Icon
        Container(
          width: iconSize,
          height: iconSize,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Container(
              height: 14,
              width: labelWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),
            // Value
            Container(
              height: 16,
              width: valueWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
