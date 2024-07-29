class QnAData {
  static List<QnList> getQnAPairs() {
    return [
      QnList(
        question: 'How can I keep my car clean?',
        answer:
            'Regularly wash your car to remove dirt and pollutants. Use a car-specific shampoo and a soft sponge. Preferably dry the car after washing to prevent stain formation.',
      ),
      QnList(
        question: 'What is the best way to maintain my car\'s engine?',
        answer:
            'Regularly check and change the oil, and ensure filters are clean or replaced. Also, keep an eye on the coolant level and maintain it within recommended levels.',
      ),
      QnList(
        question: 'How can I take care of my car\'s battery?',
        answer:
            'Ensure the battery terminals are clean and tightly secured. Use distilled water to fill batteries that have refillable cells.Regular battery checks reduce the chances of failure.',
      ),
      QnList(
        question: 'What is the optimal way to check my car\'s tire pressure?',
        answer:
            'Use a tire pressure gauge to check the tires. Ensure to check them when they are cold for an accurate reading. Follow the car manufacturer\'s recommendations for the appropriate tire pressure levels.',
      ),
      QnList(
        question: 'How can I maintain my car\'s brakes?',
        answer:
            'Regularly inspect your car\'s brakes to ensure the pads and discs are in good condition.  If you hear squealing or feel hesitation when pressing the brakes, it might be a sign that maintenance is needed.',
      ),
      QnList(
        question: 'How can I take care of my car\'s paint?',
        answer:
            'Regularly use car wax to protect the paint and give it a shine.  Avoid washing in direct sunlight and promptly remove any contaminants like bird droppings to prevent paint damage.',
      ),
      QnList(
        question:
            'What are the tips for maintaining my car\'s air conditioning system?',
        answer:
            'Run the air conditioning regularly, even on cold days, to keep the system active Checking the refrigerant and regularly replacing the filter helps maintain the efficiency of the air conditioning.',
      ),
      QnList(
        question: 'How can I keep the interior of my car clean?',
        answer:
            'Use cleaners specifically for car interiors and avoid harsh chemicals. Regularly clean vents and surfaces, and vacuum to remove dust and dirt. Preferably use car-specific air fresheners to keep the interior smelling fresh.',
      ),
      QnList(
        question: 'When should I change my tires?',
        answer:
            'Tires should be changed when the tread depth reduces to less than 1.6 mm. Use a tread depth gauge to check this. Also, replace them if you notice uneven wear or damage to the tires.',
      ),
      QnList(
        question: 'How can I take care of my car\'s exhaust system?',
        answer:
            ' Regularly inspect the exhaust system to ensure there are no leaks or damages. An exhaust leak can lead to performance issues and increased fuel consumption.',
      ),
    ];
  }
}

class QnList {
  final String question;
  final String answer;

  QnList({
    required this.question,
    required this.answer,
  });
}
