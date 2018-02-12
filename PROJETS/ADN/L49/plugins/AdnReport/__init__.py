# -*- coding: utf-8 -*-
"""
/***************************************************************************
 AdnReport
                                 A QGIS plugin
 Prégénérer les fichiers et dossier pour la génération de rapport pour ADN
                             -------------------
        begin                : 2018-01-08
        copyright            : (C) 2018 by gbruel/metis
        email                : g.bruel@metis-reseaux.fr
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
 This script initializes the plugin, making it known to QGIS.
"""


# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load AdnReport class from file AdnReport.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .Adn_Report import AdnReport
    return AdnReport(iface)
