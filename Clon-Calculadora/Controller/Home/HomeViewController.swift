import UIKit

class HomeViewController: UIViewController {
    
    // MARK: OUTLETS
    
    // Resultado
    
    @IBOutlet weak var resultDisplay: UILabel!
    
    // Números 
    
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var buttonSemiColon: UIButton!
    
    // Operadores
    
    @IBOutlet weak var buttonAC: UIButton!
    @IBOutlet weak var buttonPositiveNegative: UIButton!
    @IBOutlet weak var buttonPercent: UIButton!
    @IBOutlet weak var buttonDivide: UIButton!
    @IBOutlet weak var buttonMultiply: UIButton!
    @IBOutlet weak var buttonSubstract: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var buttonEqual: UIButton!
    
    //MARK: Variables
    
    private var total: Double = 0
    private var temp: Double = 0
    private var operating = false
    private var decimal = false
    private var operation: OperationType = .none
    
    
    // MARK: Constantes
    
    private let kDecimalSemiColon = Locale.current.decimalSeparator!
    private let kMaxLengthOnDisplay = 9
    
    private enum OperationType {
        case none, add, substract, multiply, divide, percent
    }
    
    // FORMATEADORES
    
    // Formateo de valores auxiliares
    
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateo de valores auxiliares
    
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateo de valores por pantalla
    
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    
    // Formateo de valores cientificos
    
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    
    // MARK: Inicialización
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Ciclo de vida
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI desde extensiones
        
        button0.round()
        button1.round()
        button2.round()
        button3.round()
        button4.round()
        button5.round()
        button6.round()
        button7.round()
        button8.round()
        button9.round()
        buttonSemiColon.round()
        
        buttonAC.round()
        buttonPositiveNegative.round()
        buttonPercent.round()
        buttonDivide.round()
        buttonMultiply.round()
        buttonSubstract.round()
        buttonAdd.round()
        buttonEqual.round()
        
        buttonSemiColon.setTitle(kDecimalSemiColon, for: .normal)
        
        result()
    }
    
    // MARK: ACCIONES
    
    @IBAction func actionButtonAC(_ sender: UIButton) {
        sender.shine()
        
        clear()
    }
    
    @IBAction func actionButtonPositiveNegative(_ sender: UIButton) {
        sender.shine()
        
        temp = temp * (-1)
        resultDisplay.text = printFormatter.string(from: NSNumber(value: temp))
    }
    
    @IBAction func actionButtonPercent(_ sender: UIButton) {
//        sender.shine()
        
//        if operation != .percent {
//            result()
//        }
//        operating = true
        operation = .percent
        result()
    }
    
    @IBAction func actionButtonDivide(_ sender: UIButton) {
        
        
        if operation != .none {
            result()
        }
        operating =  true
        operation = .divide
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func actionButtonMultiply(_ sender: UIButton) {
        
        
        if operation != .none {
            result()
        }
        operating =  true
        operation = .multiply
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func actionButtonSubstract(_ sender: UIButton) {
        
        
        if operation != .none {
            result()
        }
        operating =  true
        operation = .substract
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func actionButtonAdd(_ sender: UIButton) {
       
        if operation != .none {
            result()
        }
        
        operating =  true
        operation = .add
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func actionButtonEqual(_ sender: UIButton) {
        sender.shine()
        
        result()
    }
    
    @IBAction func actionButtonSemiColon(_ sender: UIButton) {
        
        
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLengthOnDisplay {
            return
        }
        
        resultDisplay.text = resultDisplay.text! + kDecimalSemiColon
        decimal = true
        
        selectVisualOperation()
        sender.shine()
    }
    
    @IBAction func actionButtonNumber(_ sender: UIButton) {
        
        print(sender.tag)
            
            buttonAC.setTitle("C", for: .normal)
            
            // Obtener la cadena actual formateada
            let currentTempString = auxTotalFormatter.string(from: NSNumber(value: temp)) ?? "0"
            
            if !operating && currentTempString.count >= kMaxLengthOnDisplay {
                return
            }
            
            // Obtener la cadena formateada actual
            var currentTemp = auxFormatter.string(from: NSNumber(value: temp)) ?? "0"
            
            // Si hemos seleccionado una operación, actualizamos `total` y reiniciamos `temp`
            if operating {
                total = total == 0 ? temp : total
                resultDisplay.text = ""
                currentTemp = ""
                operating = false
            }
            
            // Manejar el caso del decimal
            if decimal {
                if currentTemp.isEmpty {
                    currentTemp = "0"
                }
                currentTemp += kDecimalSemiColon
                decimal = false
            }
            
            // Convertir el número del botón en cadena y agregarlo a `currentTemp`
            let numberString = String(sender.tag)
            let newCurrentTemp = currentTemp + numberString
            
            // Intentar convertir la cadena resultante en Double de manera segura
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            if let tempValue = formatter.number(from: newCurrentTemp)?.doubleValue {
                temp = tempValue
            } else {
                temp = 0 // Valor por defecto en caso de error de conversión
            }
            
            // Actualizar la pantalla con el nuevo valor
            resultDisplay.text = printFormatter.string(from: NSNumber(value: temp))
            
            // Actualizar la visualización de la operación
            selectVisualOperation()
            sender.shine()
    }
    
    // Limpiar pantalla
    private func clear() {
        // Restablecer la operación actual
        operation = .none
        
        // Restablecer el título del botón
        buttonAC.setTitle("AC", for: .normal)
        
        // Restablecer los valores de la calculadora
        temp = 0
        total = 0
        resultDisplay.text = "0"
        
        // Opcionalmente, si tienes alguna lógica adicional que deba ejecutarse al limpiar, inclúyela aquí
        result() // Llama a `result()` si es necesario para actualizar el display
    }
//    private func clear() {
//        operation = .none
//        buttonAC.setTitle("AC", for: .normal)
//        
//        if temp != 0 {
//            temp = 0
//            resultDisplay.text = "0"
//        } else {
//            total = 0
//            result()
//        }
//    }
    // Obtener Resultados
    private func result () {
        switch operation {
        case .none:
            // no hay nada
            break
        case .add:
            total = total + temp
            break
        case .substract:
            total = total - temp
            break
        case .multiply:
            total = total * temp
            break
        case .divide:
            total = total / temp
            break
        case .percent:
            temp = temp / 100
            total = temp
            break
        }
        
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLengthOnDisplay {
            resultDisplay.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultDisplay.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none
        
        selectVisualOperation()
        
        print("TOTAL \(total)")
    }
    
    private func selectVisualOperation() {
        if !operating {
            buttonAdd.selectOperation(false)
            buttonSubstract.selectOperation(false)
            buttonMultiply.selectOperation(false)
            buttonDivide.selectOperation(false)
        } else {
            switch operation {
            case .none, .percent:
                buttonAdd.selectOperation(true)
                buttonSubstract.selectOperation(false)
                buttonMultiply.selectOperation(false)
                buttonDivide.selectOperation(false)
                break
            case .add:
                buttonAdd.selectOperation(true)
                buttonSubstract.selectOperation(false)
                buttonMultiply.selectOperation(false)
                buttonDivide.selectOperation(false)
                break
            case .substract:
                buttonAdd.selectOperation(false)
                buttonSubstract.selectOperation(true)
                buttonMultiply.selectOperation(false)
                buttonDivide.selectOperation(false)
                break
            case .multiply:
                buttonAdd.selectOperation(false)
                buttonSubstract.selectOperation(false)
                buttonMultiply.selectOperation(true)
                buttonDivide.selectOperation(false)
                break
            case .divide:
                buttonAdd.selectOperation(false)
                buttonSubstract.selectOperation(false)
                buttonMultiply.selectOperation(false)
                buttonDivide.selectOperation(true)
                break
            }
        }
    }
}
