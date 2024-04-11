import 'package:flutter/material.dart';

class MentorRegistrationSuccess extends StatelessWidget {
  const MentorRegistrationSuccess({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        color: const Color(0xFF8ECAE6),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/Logo1.png'),
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/Award.png',
                height: 150,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Applied Successfully',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                textAlign: TextAlign.center,
                'You have been successfully applied for the role of mentor. Wait for some days to further proceedings. Thank you!',
                style: TextStyle(
                  height: 1.5,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your button onPressed logic here
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      const Color.fromARGB(255, 2, 48, 71), // Text color
                ),
                child: const Text('See you Soon'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
