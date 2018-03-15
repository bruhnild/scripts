# -*- coding: utf-8 -*-
"""
/***************************************************************************
 AdnReport
                                 A QGIS plugin
 Prégénérer les fichiers et dossier pour la génération de rapport pour ADN
                              -------------------
        begin                : 2018-01-08
        git sha              : $Format:%H$
        copyright            : (C) 2018 by gbruel/metis
        email                : g.bruel@metis-reseaux.fr
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""
from PyQt4.QtCore import QSettings, QTranslator, qVersion, QCoreApplication
from PyQt4.QtGui import QAction, QIcon
from PyQt4 import QtGui, QtCore
import sys


# Initialize Qt resources from file resources.py
import resources
# Import the code for the dialog
from Adn_Report_dialog import AdnReportDialog
from os.path import expanduser
import os.path, csv, time, shutil # specific 


class AdnReport:
    """QGIS Plugin Implementation."""
    export_result = []

    def __init__(self, iface):
        """Constructor.

        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        """
        # Save reference to the QGIS interface
        self.iface = iface
        # initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)
        # initialize locale
        locale = QSettings().value('locale/userLocale')[0:2]
        locale_path = os.path.join(
            self.plugin_dir,
            'i18n',
            'AdnReport_{}.qm'.format(locale))

        if os.path.exists(locale_path):
            self.translator = QTranslator()
            self.translator.load(locale_path)

            if qVersion() > '4.3.3':
                QCoreApplication.installTranslator(self.translator)

        # Declare instance attributes
        self.actions = []
        self.menu = self.tr(u'&Rapport ADN')
        # TODO: We are going to let the user set this up in a future iteration
        self.toolbar = self.iface.addToolBar(u'AdnReport')
        self.toolbar.setObjectName(u'AdnReport')

    # noinspection PyMethodMayBeStatic
    def tr(self, message):
        """Get the translation for a string using Qt translation API.

        We implement this ourselves since we do not inherit QObject.

        :param message: String for translation.
        :type message: str, QString

        :returns: Translated version of message.
        :rtype: QString
        """
        # noinspection PyTypeChecker,PyArgumentList,PyCallByClass
        return QCoreApplication.translate('AdnReport', message)


    def add_action(
        self,
        icon_path,
        text,
        callback,
        enabled_flag=True,
        add_to_menu=True,
        add_to_toolbar=True,
        status_tip=None,
        whats_this=None,
        parent=None):
        """Add a toolbar icon to the toolbar.

        :param icon_path: Path to the icon for this action. Can be a resource
            path (e.g. ':/plugins/foo/bar.png') or a normal file system path.
        :type icon_path: str

        :param text: Text that should be shown in menu items for this action.
        :type text: str

        :param callback: Function to be called when the action is triggered.
        :type callback: function

        :param enabled_flag: A flag indicating if the action should be enabled
            by default. Defaults to True.
        :type enabled_flag: bool

        :param add_to_menu: Flag indicating whether the action should also
            be added to the menu. Defaults to True.
        :type add_to_menu: bool

        :param add_to_toolbar: Flag indicating whether the action should also
            be added to the toolbar. Defaults to True.
        :type add_to_toolbar: bool

        :param status_tip: Optional text to show in a popup when mouse pointer
            hovers over the action.
        :type status_tip: str

        :param parent: Parent widget for the new action. Defaults None.
        :type parent: QWidget

        :param whats_this: Optional text to show in the status bar when the
            mouse pointer hovers over the action.

        :returns: The action that was created. Note that the action is also
            added to self.actions list.
        :rtype: QAction
        """

        # Create the dialog (after translation) and keep reference
        self.dlg = AdnReportDialog()

        icon = QIcon(icon_path)
        action = QAction(icon, text, parent)
        action.triggered.connect(callback)
        action.setEnabled(enabled_flag)

        if status_tip is not None:
            action.setStatusTip(status_tip)

        if whats_this is not None:
            action.setWhatsThis(whats_this)

        if add_to_toolbar:
            self.toolbar.addAction(action)

        if add_to_menu:
            self.iface.addPluginToMenu(
                self.menu,
                action)

        self.actions.append(action)

        return action

    def initGui(self):
        """Create the menu entries and toolbar icons inside the QGIS GUI."""

        icon_path = ':/plugins/AdnReport/icon.png'
        self.add_action(
            icon_path,
            text=self.tr(u'Rapports ADN'),
            callback=self.run,
            parent=self.iface.mainWindow())


    def unload(self):
        """Removes the plugin menu item and icon from QGIS GUI."""
        for action in self.actions:
            self.iface.removePluginMenu(
                self.tr(u'&Rapport ADN'),
                action)
            self.iface.removeToolBarIcon(action)
        # remove the toolbar
        del self.toolbar


    def isInList(self, val, li):
        """Return index of value find in list or -1 if value is not exist in list"""
        res = False        
        if val and li:
            try :
                res = li.index(val)                
            except ValueError:
                res = False
        return res    
    
    def rmDblToCombo(self,array,cb):
        cb.clear() # clean
        cb.addItem("Select all opportunity")
        """Remove dupplicate value from given array and import unic values to given combo"""
        cb.setEnabled(True);        
        t = list(set(array))
        clean = []
        for elem in t:
            typeVar = type(elem).__name__
            if typeVar == "unicode" or typeVar == "str":                
                if cb.findText(elem) < 0:
                    clean.append(elem)
                    cb.addItem(elem)                    
        return clean
        
    
    def searchFile(self):        
        wrongText = "Please, select valid file !"
        """Open window to search template file"""
        """Update text box with path value"""
        def test(string, expression):
            test = False
            if string in expression:
                test = True
            return test                
        file = QtGui.QFileDialog.getOpenFileName(None, 'Open file')
        if os.path.exists(file) :
            # control file is valid
            for elem in ["xls","xlsm"]:
                isValid = test(elem, file)                
                if isValid:
                    return self.dlg.pathTpl.setText(file)
                else :
                    
                    return self.dlg.pathTpl.setText(wrongText)
        else :
            self.dlg.pathTpl.setText(wrongText)

    def searchFolder(self):
        """Method to get path in order to export file to path"""        
        folder = QtGui.QFileDialog.getExistingDirectory(None, 'Open folder', expanduser('~'))       
        """Update text box with path value"""
        self.dlg.pathFolder.setText(folder)

    def getLayerFromCb(self, cbString):
        """Function to return layer item from combo string value"""
        res = False
        # get layers from qgis interface
        layers = self.iface.legendInterface().layers()
        for x in layers:
            if x.name() == cbString:
                res = x
                break
        return res
        
    def layersToCombo(self, combo):
        """Create array from interface layers to be insert in given combobox """
        layer = ""
        layer_list= []
        # get layers from qgis interface
        layers = self.iface.legendInterface().layers()
        for layer in layers:
            if layer.name() and layer.type() == 0:
                layer_list.append(layer.name())
        combo.addItems(layer_list)

    def getLayerFields(self,layer):
        fieldsName = []
        """parse layer to get opportunity values"""        
        fields = layer.dataProvider().fields()
        for field in fields:
            fieldsName.append(field.name())
        return fieldsName

    def fieldValues(self, layer, val):
        # retourne les valeurs pour un champ donné dans une couche donnée
        """if user select layer in combo, return attributes as list """        
        res = False
        if val != "":                    
            cbList = []            
            fields = self.getLayerFields(layer) # list of fields            
            idx = self.isInList(val, fields) # control if field exist in layer            
            # Correction apply : if index is first, index = int(0). So, python indentify index as False.
            if idx != False or idx > -1:                
                features = layer.getFeatures() # array that contain all attributes values without fields name
                for el in features:
                    cbList.append(el.attributes()[idx])                    
            res = cbList # return list of opportunity states values            
        return res

    def oppFiltering(self, idFromGc, idFromSy, gcLayer, syLayer, cbOfState, cbO):   
        """return opportunity according to state value or not"""
        finalAttr = []            
        def getOppFromLayer (layer, cbId, cbSt, cbOp):
            oppResult = []
            layerRead = self.getLayerFromCb(layer.currentText())
            idLayer = cbId.currentText()
            state = cbSt.currentText()
            defaultValue = cbSt.itemText(0)
            if layerRead != False:
                cbOp.clear()
                self.export_result = {}                
                filterVal = []         
                cbOp.addItem("Select all opportunity")                   
                # return list of id for gc layer            
                layerOpp = self.fieldValues(layerRead, idLayer)                
                # return all features                
                layerFeatures = layerRead.getFeatures()
                # return all fields                
                layerFields = self.getLayerFields(layerRead)
                # return position of given field in layer fields                            
                posId = self.isInList(idLayer, layerFields) # to get id attributes # bug            
                posState = self.isInList("statut",layerFields) # si on a bien le champ statut donne alors la position du champ, sinon renvoi false                   
                                
                if posState != False or posState > -1:                    
                    filterVal = self.fieldValues(layerRead,"statut")                            
                
                for feature in layerFeatures: # on regarde toutes les features de la couche
                    idAttr = feature.attributes()[posId] # on prend la valeur de l'id pour la feature                    
                    if state == defaultValue :
                        oppResult.append(idAttr)
                    else:
                        stateAttr = feature.attributes()[posState] # on prend le statut pour cette même feature                                        
                        isFilter = self.isInList(state,filterVal) # on test si la valeur sélectionnée est dans la liste des statuts                
                        if isFilter != False or isFilter > -1: # si c'est le cas, alors on filtre                                                                    
                            if stateAttr == state: # on filtre donc sur le statut souhaité pour ne prendre que les features qui ont un statut identique au statut sélectionné                            
                                oppResult.append(idAttr) # on ajoutera la feature dans une liste        
            return oppResult
        # return sum of opportunity for each combo whithout duplicate value
        listGc = getOppFromLayer(gcLayer, idFromGc, cbOfState, cbO)  
        listSy = getOppFromLayer(syLayer, idFromSy, cbOfState, cbO)
        finalAttr = listGc + listSy
        
        return self.rmDblToCombo(finalAttr,cbO)
    
    def cbStateEl(self, combo):
        # get count of cb items and returns the text for the given index in the combobox
        cbData = []
        for i in range(combo.count()):
            cbData.append(combo.itemText(i))
        return cbData     
        
    def cbUpdate(self,cb,val):
        """Function to parse state combo list and remove state not listed in selected ids"""        
        attributes = []
        cb.clear()
        cb.addItem("Select all " + val)# display default message                
        layerGC = self.getLayerFromCb(self.dlg.comboGC.currentText())        
        layerSynthese = self.getLayerFromCb(self.dlg.comboSynthese.currentText())
        if layerGC != False :
            listValuesGc = self.fieldValues(layerGC,val)            
            if listValuesGc != False :
                attributes = attributes + listValuesGc
        if layerSynthese != False:
            listValuesSynthese = self.fieldValues(layerSynthese,val)
            if listValuesSynthese != False:
                attributes = attributes + listValuesSynthese # list all opportunity from layers        
        if len(attributes)>0:
            cb.setEnabled(True);   
            self.rmDblToCombo(attributes,cb)
        else :            
            cb.setEnabled(False)
    def createFile(self):
        """create folder to contain report by opportunity"""        
        listOpp = self.cbStateEl(self.dlg.cbOpp)  
        layers = [
            self.getLayerFromCb(self.dlg.comboGC.currentText()),
            self.getLayerFromCb(self.dlg.comboSynthese.currentText())            
        ]                 
        selectOpp = self.dlg.cbOpp.currentText() #get selected value in combo
        defaultValue = self.dlg.cbOpp.itemText(0)
        if(selectOpp) != defaultValue:
            listOpp = [selectOpp]        
        # use this code if user select all
        if len(listOpp)>1:
            del(listOpp[0])
        for opp in listOpp:            
            '''create folder'''
            folder = self.dlg.pathFolder.text() + "/"+opp
            if not os.path.exists(folder):
                os.makedirs(folder)
            '''copy template'''
            template = self.dlg.pathTpl.text()    
            if os.path.exists(template) :                 
                # here get file fomat
                pathF = template.split(".")
                formatF = pathF[len(pathF)-1]
                # save template with opp name
                target = folder + "/" + opp + "."+ formatF
                shutil.copy(template, target)
                '''export to csv'''
                for layer in layers: # treat per layer
                    if layer != False:
                        docName = False
                        # create csv file
                        if "gc" in layer.name() or "GC" in layer.name() or "Gc" in layer.name():
                            docName = folder+"/gc.csv"             
                        elif "synthese" in layer.name() or "Synthese" in layer.name() or "Synthèse" in layer.name() or "synthèse" in layer.name(): 
                            docName = folder+"/synthese.csv"
                        # control docname is not wrong
                        if docName != False:
                            output_file = open(docName,"w")
                            # get and add fields to csv
                            fields = layer.pendingFields()
                            fieldname = [field.name() for field in fields]
                            lineField = line = ",".join(fieldname) + "\n"
                            unicode_fields = lineField.encode("utf-8")                                        
                            output_file.write(unicode_fields)
                            # filter features to add to csv
                            features = layer.getFeatures()                                       
                            for f in features:                      
                                # get attribute  
                                attr = [el for el in f.attributes()]
                                # parse all feature's values
                                for val in range(len(attr)):
                                    item = attr[val]                                                                                       
                                    if item == opp:                                         
                                        find = self.isInList(val, listOpp)                                
                                        # if feature is search write in csv
                                        if find != False or find > -1:
                                            line = ",".join(unicode(f[x]) for x in fieldname) + "\n"
                                            unicode_line = line.encode("utf-8")                                
                                            output_file.write(unicode_line)                        
                            output_file.close()                                                    
    def updateCbId(self,val,combo,st):        
        """We begin by activate state combo and load this combo by states values"""
        self.cbUpdate(st, "statut")
        """Search Id in given layer's fields name and load fields name in this combo"""
        selectLayer = ""
        fieldsName = []
        idFind = ""
        layers = self.iface.legendInterface().layers()
        idx = 0
        """Get layer's name selected in combobox and return real layer object from Qgis canvas"""
        selectLayer = self.getLayerFromCb(val)
        """From layer parse fields and return field name that contain "id" value """
        if combo and val and (selectLayer != False) :
            # update id combo
            combo.clear()
            combo.setEnabled(True)
            fieldsName = self.getLayerFields(selectLayer) # get fields name
            combo.addItems(fieldsName) # load values in combo id
            """Search first occurency that contain "id" value and define as default index"""
            for name in fieldsName:
                if ("id" in name) or ("Id" in name) or ("ID" in name) or ("iD" in name): # if field name contain "id" str we set this name index by default combo value
                    idx = fieldsName.index(name)
                    break
            combo.setCurrentIndex(idx)
        else:
            """Restore default combo state"""
            combo.clear()            
            combo.addItem("Select id")
            combo.setEnabled(False)

    def controlInput(self):
        filePath = self.dlg.pathTpl.text()
        folderPath = self.dlg.pathFolder.text()
        if len(self.cbStateEl(self.dlg.cbOpp))<1 or not os.path.exists(filePath) or not os.path.exists(folderPath):
            self.dlg.textInfos.setText("Informations are missing or incorrects !")          
        else :             
            return self.createFile()
    """Init combo elements"""
    def initCb (self, cb, cbId, cbSt):
        #load layer list to combobox        
        self.layersToCombo(cb)
        # event on clic        
        cb.currentIndexChanged.connect(lambda: self.updateCbId(cb.currentText(), cbId, cbSt))   
        
    def run(self):
        """Run method that performs all the real work"""
        # show the dialog
        self.dlg.show()
        """"To connect event to gui elements"""
        cbGC = self.dlg.comboGC
        cbSynthese = self.dlg.comboSynthese
        cbGcId = self.dlg.idGC
        cbSyntheseId = self.dlg.idSynthese
        cbState = self.dlg.cbState
        cbOpp = self.dlg.cbOpp
        # init combo
        self.initCb(cbGC, cbGcId,cbState)
        self.initCb(cbSynthese, cbSyntheseId,cbState)
        # buttons
        self.dlg.buttonFile.clicked.connect(self.searchFile) 
        self.dlg.buttonFolder.clicked.connect(self.searchFolder)        

        '''here we need to load opportunity list wehen user select id field to get opp values'''        
        for el in [cbGcId, cbSyntheseId, cbState] :
            el.currentIndexChanged.connect(lambda: self.oppFiltering(cbGcId, cbSyntheseId, cbGC, cbSynthese, cbState, cbOpp))
        self.state = []        
        # Run the dialog event loop
        result = self.dlg.exec_()
        # See if OK was pressed
        if result:
            # Do something useful here - delete the line containing pass and            
            self.controlInput()
            # substitute with your code.
            pass
