import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/enum/enum.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:flutter_getx_boilerplate/shared/widgets/image/image_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';

class OnboardItem {
  final String image;
  final String title;
  final String content;
  final IconData icon;

  const OnboardItem({
    required this.image,
    required this.title,
    required this.content,
    required this.icon,
  });
}

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;

  final List<OnboardItem> _onboardItems = [
    const OnboardItem(
      image: 'https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      title: 'Secure Vaccine Tracking',
      content: 'Keep track of your vaccination records safely and securely with our advanced digital system.',
      icon: Icons.security,
    ),
    const OnboardItem(
      image: 'https://images.pexels.com/photos/1592384/pexels-photo-1592384.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      title: 'Family Health Management',
      content: 'Manage vaccination schedules for your entire family in one convenient place.',
      icon: Icons.family_restroom,
    ),
    const OnboardItem(
      image: 'https://images.pexels.com/photos/13861/IMG_3496bfree.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      title: 'Expert Medical Guidance',
      content: 'Get personalized vaccine recommendations and reminders from healthcare professionals.',
      icon: Icons.medical_services,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    Future.delayed(const Duration(seconds: 1), () {
      StorageService.firstInstall = false;
    });

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < _onboardItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _onBackPressed() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    NavigatorHelper.toAuth();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button at top
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: ColorConstants.primaryGreen,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardItems.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: OnboardPage(item: _onboardItems[index]),
                      );
                    },
                  );
                },
              ),
            ),

            // Bottom controls
            Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _onboardItems.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                      activeDotColor: ColorConstants.primaryGreen,
                      dotColor: Colors.grey.shade300,
                      expansionFactor: 3,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        TextButton(
                          onPressed: _onBackPressed,
                          child: Text(
                            'Back',
                            style: TextStyle(
                              color: ColorConstants.primaryGreen,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else
                        SizedBox(width: 60.w),

                      ElevatedButton(
                        onPressed: _onNextPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 16.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          _currentPage == _onboardItems.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardPage extends StatelessWidget {
  final OnboardItem item;

  const OnboardPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: ColorConstants.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 60.w,
              color: ColorConstants.primaryGreen,
            ),
          ),
          SizedBox(height: 40.h),

          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ImageWidget(
              item.image,
              width: 80.wp,
              height: 35.hp,
              radius: 0,
              borderRadius: const BorderRadius.all(Radius.circular(0)),
            ),
          ),
          SizedBox(height: 40.h),

          // Title
          Text(
            item.title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),

          // Content
          Text(
            item.content,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
