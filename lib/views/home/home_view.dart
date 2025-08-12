import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/my_enum.dart';
import 'package:gym_zones/views/home/widgets/ad_card.dart';
import 'package:gym_zones/views/home/widgets/free_week_card.dart';
import 'package:gym_zones/views/home/widgets/home_app_bar.dart';
import 'package:gym_zones/views/home/widgets/individual_gym_section.dart';
import 'package:gym_zones/views/home/widgets/nearest_gym_section.dart';
import 'package:gym_zones/views/home/widgets/offer_section.dart';
import 'package:gym_zones/views/home/widgets/our_services_card.dart';
import 'package:gym_zones/views/home/widgets/statistics_card.dart';
import 'package:gym_zones/views/offers/controller/offer_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../common/navigation/app_routes.dart';
import '../../common/widgets/custom_bottom_nav_bar.dart';
import '../../common/widgets/loading_widget.dart';
import '../../controllers/home_controller.dart';
import 'widgets/top_user_card.dart';

// Wrapper to keep widgets alive when off-screen
class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OfferController());
    initializeDateFormatting('ar', null);

    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return Scaffold(
          appBar: buildHomeAppBar(ctrl),
          body: SafeArea(
            child: ctrl.nearestGyms == [] ||
                    ctrl.topUsers == [] ||
                    ctrl.isLoading
                ? const LoadingWidget()
                : RefreshIndicator(
                    onRefresh: ctrl.refreshView,
                    child: CustomScrollView(
                      controller: ctrl.scrollController,
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.all(16.w),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              InkWell(
                                  onTap: () =>
                                      Get.toNamed(AppRoutes.successPayment),
                                  child: Text("Go to succsses")),
                              SizedBox(
                                height: 3.h,
                              ),
                              GestureDetector(
                                onTap: () => Get.toNamed(AppRoutes.search),
                                child: Material(
                                  elevation: 2.h,
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: TextField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: 'Search gyms...'.tr,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.search_rounded,
                                          color: Colors.grey[400],
                                          size: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (ctrl.user == null ||
                                  (ctrl.user!.subscriptionType ==
                                          SubscriptionType.trial.name &&
                                      ctrl.user!.subscriptionStatus ==
                                          SubscriptionStatus
                                              .inactive.name)) ...[
                                SizedBox(height: 16.h),
                                const FreeWeekCard()
                              ],
                              SizedBox(
                                height: 16.h,
                              ),
                              if (ctrl.user != null &&
                                  (ctrl.user!.hasSubscription ||
                                      ctrl.user!.subscriptionType ==
                                          SubscriptionType.both.name ||
                                      ctrl.user!.subscriptionType ==
                                          SubscriptionType
                                              .individual.name)) ...[
                                buildStatisticsCard(ctrl)
                              ],
                              SizedBox(
                                height: 24.h,
                              ),
                              if (ctrl.ad.data != null) ...[
                                Text("Advertisements".tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp)),
                                CarouselSlider.builder(
                                  itemCount: ctrl.ad.data!.length,
                                  itemBuilder: (context, index, realIdx) {
                                    final ad = ctrl.ad.data![index];
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) => ctrl
                                            .imageIndexHomepage.value = index);
                                    return AdCard(ad: ad);
                                  },
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Obx(
                                  () => SizedBox(
                                    width: Get.width,
                                    child: Center(
                                      child: AnimatedSmoothIndicator(
                                        activeIndex:
                                            ctrl.imageIndexHomepage.value,
                                        count: ctrl.ad.data!.length,
                                        effect: ExpandingDotsEffect(
                                          dotHeight: 6.h,
                                          dotWidth: 6.w,
                                          spacing: 10.w,
                                          dotColor: const Color(0x4C111827),
                                          activeDotColor:
                                              const Color(0xFF374151),
                                          paintStyle: PaintingStyle.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              SizedBox(
                                height: 16.h,
                              ),
                              if (ctrl.topUsers!.isNotEmpty) ...[
                                SizedBox(height: 16.h),
                                Text(
                                  // '${'🔥 Top in'.tr} ${DateFormat.MMMM(Get.locale!.languageCode).format(DateTime.now())}'.tr,
                                  'Top ten athletes'.tr,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                CarouselSlider.builder(
                                  itemCount: ctrl.topUsers!.length,
                                  itemBuilder: (context, index, realIdx) =>
                                      TopUserCard(user: ctrl.topUsers![index]),
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    viewportFraction: 0.5,
                                  ),
                                ),
                              ],
                              SizedBox(height: 16.h),
                            ]),
                          ),
                        ),
                        SliverPersistentHeader(
                          floating: true,
                          pinned: true,
                          delegate: RowServiceHeaderDelegate(
                            ctrl: ctrl,
                            height: 50.h,
                          ),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.all(16.w),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              _KeepAliveWrapper(
                                child: OurServicesCard(
                                  key: ctrl.ourServicesKey,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              _KeepAliveWrapper(
                                child: NearesetGymSection(ctrl: ctrl),
                              ),
                              SizedBox(height: 8.h),
                              _KeepAliveWrapper(
                                child: IndividualGymsSection(ctrl: ctrl),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              _KeepAliveWrapper(
                                child: OfferSection(
                                  key: ctrl.offersKey,
                                  ctrl: ctrl,
                                ),
                              ),
                              SizedBox(
                                  height: 20.h), // Bottom padding for last item
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          bottomNavigationBar: CustomBottomNavBar(),
        );
      },
    );
  }
}
