//
//  ComidasViewController.m
//  DiabetesTest
//
//  Created by Federico Bustos Fierro on 8/30/15.
//  Copyright (c) 2015 Federico Bustos Fierro. All rights reserved.
//

#import "ComidasViewController.h"
#import "FoodTableViewCell.h"
#import "PureLayout.h"
#import "AppDelegate.h"
#import "StepOneViewController.h"

@interface ComidasViewController ()
<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* sectionsArray;
@property (nonatomic, strong) NSMutableDictionary* selectionsDictionary;
@end

@implementation ComidasViewController {
    CGFloat valorTotal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"plist"];
    NSDictionary* root = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    self.sectionsArray = [NSMutableArray new];
    self.selectionsDictionary = [NSMutableDictionary new];
    
    for (NSString* str in root [@"types"]) {
    
        NSArray* array = root [str];
    
        [self.sectionsArray addObjectsFromArray:array];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionsArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* items = [self dataSourceForKey:self.sectionsArray [section]];
    return items.count;
}

- (NSArray*) dataSourceForKey: (NSString*) key {

    NSString *filePath = [[NSBundle mainBundle] pathForResource:key ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray *result = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    return result;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 40;

}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView* v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithRed:255/255.f green:33/255.f blue:162/255.f alpha:.8f];
                         
    
    UILabel* lbl = [[UILabel alloc] initForAutoLayout];
    lbl.text = self.sectionsArray [section];
    lbl.textColor = [UIColor whiteColor];
    [v addSubview:lbl];
    [lbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    
    return v;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell" forIndexPath:indexPath];
    
    NSArray* items = [self dataSourceForKey:self.sectionsArray [indexPath.section]];
    FoodItem* foodItem = [FoodItem new];
    [foodItem configureWithDict:items [indexPath.row]];
    [cell setUpWithFoodItem: foodItem];
    
    if ([self.selectionsDictionary objectForKey:foodItem.identificationKey]) {
    
        cell.amountTextfield.text = [NSString stringWithFormat:@"%lu", [[self.selectionsDictionary objectForKey:foodItem.identificationKey] integerValue]];
        
    }
    else {
        cell.amountTextfield.text = @"0";
    }
    
    return cell;
}

- (IBAction)selectCategory:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Tipo de Alimento"
                                  message:@"Por favor seleccione el grupo al que pertenece el alimento que desea buscar:"
                                  preferredStyle:UIAlertControllerStyleAlert];

    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"plist"];
    NSDictionary* root = [NSDictionary dictionaryWithContentsOfFile:plistPath];

    for (NSString* str in root [@"types"]) {
        UIAlertAction* action = [UIAlertAction
                                   actionWithTitle:str
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       [self selectSubategoryForCategory:str];
                                   }];
        [alert addAction:action];
    }
    
    UIAlertAction* cancelar = [UIAlertAction
                           actionWithTitle:@"Cancelar"
                           style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * action)
                           {
                               [alert dismissViewControllerAnimated:YES completion:nil];
                           }];
    [alert addAction:cancelar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void) selectSubategoryForCategory: (NSString*) category {

    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Categoría de Alimento"
                                  message:@"Por favor seleccione la categoria a la que pertenece el alimento que desea buscar:"
                                  preferredStyle: (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)? UIAlertControllerStyleAlert: UIAlertControllerStyleActionSheet];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FoodList" ofType:@"plist"];
    NSDictionary* root = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray* array = root [category];
    
    for (NSString* subcategory in array) {
        UIAlertAction* action = [UIAlertAction
                                   actionWithTitle:subcategory
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [self scrollToCategory:subcategory];
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];
        [alert addAction:action];
    }
    
    UIAlertAction* cancelar = [UIAlertAction
                               actionWithTitle:@"Volver"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   [self selectCategory:nil];
                               }];
    [alert addAction:cancelar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void) scrollToCategory: (NSString*) category {

    NSInteger section = [self.sectionsArray indexOfObject:category];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (IBAction)porcionPlus:(id)sender {
    
    
    
    UIButton* button = (UIButton*) sender;
    
    FoodTableViewCell* cell;
    
    
    
    if ([button.superview isKindOfClass:[FoodTableViewCell class]]) {
        
        cell = (FoodTableViewCell*) button.superview;
        
    }
    
    
    
    if ([button.superview.superview isKindOfClass:[FoodTableViewCell class]]) {
        
        cell = (FoodTableViewCell*) button.superview.superview;
        
    }
    
    
    
    if ([button.superview.superview.superview isKindOfClass:[FoodTableViewCell class]]) {
        
        cell = (FoodTableViewCell*) button.superview.superview.superview;
        
    }
    
    
    
    
    
    NSLog(@"cell? %@ other? %@", button.superview, button.superview.superview.superview);
    
    
    
    
    
    [self performSelector:@selector(updateDictionaryWithCell:) withObject:cell afterDelay:.1f];
    
    
    
}



- (IBAction)porcionLess:(id)sender {
    
    
    
    UIButton* button = (UIButton*) sender;
    
    FoodTableViewCell* cell;
    
    
    
    if ([button.superview isKindOfClass:[FoodTableViewCell class]]) {
        
        cell = (FoodTableViewCell*) button.superview;
        
    }
    
    
    
    if ([button.superview.superview isKindOfClass:[FoodTableViewCell class]]) {
        
        cell = (FoodTableViewCell*) button.superview.superview;
        
    }
    
    
    
    NSLog(@"cell? %@ other? %@", button.superview, button.superview.superview);
    
    
    
    
    
    [self performSelector:@selector(updateDictionaryWithCell:) withObject:cell afterDelay:.1f];
    
    
    
}

- (void) updateDictionaryWithCell: (FoodTableViewCell*) cell {
    
    FoodItem* item = cell.foodItem;
    NSInteger value = [cell.amountTextfield.text integerValue];
    [self.selectionsDictionary setObject:[NSNumber numberWithInteger:value] forKey:item.identificationKey];
}

- (IBAction)search:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Búsqueda de Alimento"
                                  message:@"Por favor escriba una palabra clave que identifique al alimento que busca:"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:nil];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alert.textFields[0];
        NSLog(@"text was %@", textField.text);
        [self selectSearchResultForString:textField.text];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancel pressed");
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) selectSearchResultForString: (NSString*) string {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Resultado de Búsqueda"
                                  message:@"Por favor seleccione el resultado que más se aproxime al alimento que desea agregar:"
                                  preferredStyle:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)? UIAlertControllerStyleAlert: UIAlertControllerStyleActionSheet];
    

    NSMutableArray* allItems = [NSMutableArray new];
    
    for (NSString* key in self.sectionsArray) {
        NSArray* items = [self dataSourceForKey:key];
        NSMutableArray* titles = [NSMutableArray new];
        for (NSDictionary* dictItem in items) {
            [titles addObject:dictItem[@"Comida"]];
        }
        
        [allItems addObjectsFromArray:titles];
    }
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", string];
    NSArray* filteredArray = [allItems filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count==0) {

        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:@"Resultado Nulo" message:[NSString stringWithFormat:@"No se ha encontrado ningún elemento que contenga la palabra: %@", string] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert2 show];
        return;
    
    }
    
    if (filteredArray.count>=100) {
        
        UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:@"Demasiados Resultados" message:[NSString stringWithFormat:@"Usted ha utilizado una palabra demasiado genérica (%@), por favor repita la búsqueda utilizando un término más específico", string] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert2 show];
        return;
        
    }
    
    
    for (NSString* item in filteredArray) {
        UIAlertAction* action = [UIAlertAction
                                 actionWithTitle:item
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self scrollToItem:item];
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:action];
    }
    
    UIAlertAction* cancelar = [UIAlertAction
                               actionWithTitle:@"Volver"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   [self search:nil];
                               }];
    [alert addAction:cancelar];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void) scrollToItem: (NSString*) item {

    NSMutableArray* allItems = [NSMutableArray new];
    NSString* sectionKey;
    NSInteger rowNumber = 0;
    for (NSString* key in self.sectionsArray) {
        NSArray* items = [self dataSourceForKey:key];
        NSMutableArray* titles = [NSMutableArray new];
        for (NSDictionary* dictItem in items) {
            [titles addObject:dictItem[@"Comida"]];
        }
        if ([titles containsObject:item]) {
            sectionKey = key;
        }
        
        for (int x = 0; x < titles.count; x++) {
            if ([titles[x] isEqualToString:item]) {
                rowNumber = x;
            }
        }
        
    }
    
    NSInteger section = [self.sectionsArray indexOfObject:sectionKey];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (IBAction)calcularTotal:(id)sender {

    valorTotal = [self valorSumaTotal];
    if (valorTotal==-1) {
        return;
    }
    
    self.selectionsDictionary = [NSMutableDictionary new];
    [self performSegueWithIdentifier:@"displayFlow" sender:nil];
    [self performSelector:@selector(changeTab) withObject:nil afterDelay:1];
    [self.tableView reloadData];
    
}

- (CGFloat) valorSumaTotal {
    
    CGFloat totalValue = 0;
    
    NSString* descriptor = @"";
    
    NSMutableArray* allItems = [NSMutableArray new];
    
    for (NSString* key in self.sectionsArray) {
        NSArray* items = [self dataSourceForKey:key];
        NSMutableArray* foodItems = [NSMutableArray new];
        for (NSDictionary* dictItem in items) {
            
            FoodItem* foodItem = [FoodItem new];
            [foodItem configureWithDict:dictItem];
            [foodItems addObject: foodItem];
        }
        
        [allItems addObjectsFromArray:foodItems];
    }

    for (NSString* key in [self.selectionsDictionary allKeys]) {
    
        FoodItem* myItem;
        for (FoodItem* item in allItems) {
            if ([item.identificationKey isEqualToString:key]) {
                myItem = item;
            }
        }
        
        CGFloat value = myItem.glucidos;
        NSInteger amount = [self.selectionsDictionary [key] integerValue];
        
        NSString *shortString = ([myItem.comida length]>18 ? [NSString stringWithFormat:@"%@...", [myItem.comida substringToIndex:15]] : myItem.comida);
        
        descriptor = [NSString stringWithFormat:@"%@\n%@: %lu x %.1fg = %.1fg",descriptor, shortString, amount,myItem. glucidos, myItem.glucidos * amount];
        NSLog(@"Item %@: value %f x amount %lu", myItem.comida, myItem.glucidos, amount);
        
        totalValue = totalValue + (value*amount);
        
    }
    
    if (self.selectionsDictionary.allKeys.count == 0) {
    
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Por favor agrega al menos una porción en alguno de los items disponibles para poder continuar."] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
        [alert show];
        return -1;
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Total de Carbohidratos" message:[NSString stringWithFormat:@"Se ha calculado un valor total de %.2fg para los siguientes items: %@", totalValue, descriptor] delegate: nil cancelButtonTitle: nil otherButtonTitles: @"De acuerdo", nil];
    [alert show];
    
    return totalValue;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"displayFlow"]) {
        StepOneViewController* nextVC = (StepOneViewController*) segue.destinationViewController;
        nextVC.preloadedCH = valorTotal;
    }
}


- (void) changeTab {

    
    AppDelegate* appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.tabVC.selectedIndex = 0;
    
}
@end
