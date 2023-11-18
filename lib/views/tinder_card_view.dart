import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../provider/card_provider.dart';

class TinderCardView extends StatefulWidget {
  final String? image;
  final bool isFront;
  const TinderCardView({
    super.key,
    this.image,
    required this.isFront,
  });

  @override
  State<TinderCardView> createState() => _TinderCardViewState();
}

class _TinderCardViewState extends State<TinderCardView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final cardProvider = Provider.of<CardProvider>(context, listen: false);
      cardProvider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 100,
      ),
      child: SizedBox.expand(
        child: SingleChildScrollView(
            child: widget.isFront ? buidFrontCard(context) : buildCard()),
      ),
    );
  }

  Widget buidFrontCard(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.startPosition(details);
      },
      onPanEnd: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.endPosition(details);
      },
      onPanUpdate: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.updatePosition(details);
      },
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final cardProvider = Provider.of<CardProvider>(
            context,
          );
          final milliseconds = cardProvider.isDragging ? 0 : 400;
          final center = constraints.smallest.center(Offset.zero);
          final position = cardProvider.posiiton;
          final angle = cardProvider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
              color: Colors.white,
              duration: Duration(milliseconds: milliseconds),
              curve: Curves.easeInOut,
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: buildCard());
        },
      ),
    );
  }

  Widget buildCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            height: 600,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: widget.image ??
                'https://plus.unsplash.com/premium_photo-1669324357471-e33e71e3f3d8?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            imageBuilder: (context, imageProvider) => Container(
              height: 600,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'name',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
