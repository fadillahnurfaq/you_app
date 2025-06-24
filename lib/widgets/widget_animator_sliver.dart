import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class EmptyWidgetSliver extends StatelessWidget {
  final String message;
  const EmptyWidgetSliver({
    super.key,
    this.message = "",
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.noData.image(
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          if (message.isNotEmpty) ...[
            const SpaceHeight(10.0),
            AppText(
              text: message,
              align: TextAlign.center,
              textStyle: AppTextStyle.h4,
            )
          ]
        ],
      ),
    );
  }
}

class ErrorWidgetSliver extends StatelessWidget {
  final String message;
  const ErrorWidgetSliver({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning,
            size: 35.0,
            color: AppColors.primary,
          ),
          const SpaceHeight(10.0),
          AppText(
            text: message,
            align: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class LoadingWidgetSliver extends StatelessWidget {
  const LoadingWidgetSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class WidgetAnimatorSliver<T> extends StatelessWidget {
  final RequestState requestState;
  final Widget? emptySliver;
  final Widget? loadingSliver;
  final List<Widget> Function(T? result) successSliver;
  final Widget Function(String message)? errorWidget;
  final ScrollController? scrollController;
  final Future<void> Function() onRefresh;
  final String messageEmpty;
  const WidgetAnimatorSliver({
    super.key,
    required this.onRefresh,
    required this.requestState,
    required this.successSliver,
    this.emptySliver,
    this.loadingSliver,
    this.errorWidget,
    this.scrollController,
    this.messageEmpty = "",
  });

  @override
  Widget build(BuildContext context) {
    return AppRefresher(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: requestState is RequestStateLoaded
            ? successSliver((requestState as RequestStateLoaded<T>).result)
            : [
                _getChild(),
              ],
      ),
    );
  }

  _getChild() {
    if (requestState is RequestStateError) {
      final message = (requestState as RequestStateError).message;
      if (errorWidget != null) {
        return errorWidget!(message);
      } else {
        return ErrorWidgetSliver(message: message);
      }
    } else if (requestState is RequestStateInitial) {
      return const SliverToBoxAdapter();
    } else if (requestState is RequestStateEmpty) {
      if (emptySliver != null) {
        return emptySliver!;
      } else {
        return EmptyWidgetSliver(
          message: messageEmpty,
        );
      }
    } else if (requestState is RequestStateLoading) {
      if (loadingSliver != null) {
        return loadingSliver!;
      } else {
        return const LoadingWidgetSliver();
      }
    }
  }
}
